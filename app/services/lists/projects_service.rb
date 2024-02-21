module Lists
  class ProjectsService < BaseService
    def initialize(team, user, folder, params)
      @team = team
      @user = user
      @current_folder = folder
      @params = params
      @filters = params[:filters] || {}
      @records = []
    end

    def call
      projects = fetch_projects
      folders = fetch_project_folders

      projects = filter_project_records(projects)
      folders = filter_project_folder_records(folders)

      if @filters[:folder_search].present? && @filters[:folder_search] == 'true'
        @records = projects
      else
        projects = projects.where(project_folder: @current_folder)
        folders = folders.where(parent_folder: @current_folder)

        @records = Project.from("((#{projects.to_sql}) UNION ALL (#{folders.to_sql})) AS projects")
      end

      sort_records
      paginate_records
      @records
    end

    private

    def fetch_projects
      @team.projects
           .includes(:team, user_assignments: %i(user user_role))
           .includes(:project_comments, experiments: { my_modules: { my_module_status: :my_module_status_implications } })
           .visible_to(@user, @team)
           .left_outer_joins(:project_comments)
           .select('projects.team_id',
                   'projects.created_at',
                   'projects.archived_on',
                   'projects.default_public_user_role_id',
                   'projects.name',
                   'projects.id')
           .select('COUNT(DISTINCT comments.id) AS comment_count',
                   '0 AS projects_count',
                   '0 AS folders_count',
                   '1 as type')
           .group('projects.id')
    end

    def fetch_project_folders
      project_folders = @team.project_folders
                             .includes(:team)
                             .joins('LEFT OUTER JOIN project_folders child_folders
                                    ON child_folders.parent_folder_id = project_folders.id')
                             .left_outer_joins(:projects)
      project_folders.select('project_folders.team_id',
                             'project_folders.created_at',
                             'project_folders.archived_on',
                             '0 AS default_public_user_role_id',
                             'project_folders.name',
                             'project_folders.id')
                     .select('COUNT(DISTINCT projects.id) AS projects_count')
                     .select('COUNT(DISTINCT child_folders.id) AS folders_count')
                     .select('0 AS comment_count', '0 AS type')
                     .group('project_folders.id')
    end

    def filter_project_records(records)
      records = records.archived if @params[:view_mode] == 'archived'
      records = records.active if @params[:view_mode] == 'active'

      if @params[:search].present?
        records = records.where_attributes_like(['projects.name', Project::PREFIXED_ID_SQL], @params[:search])
      end

      if @filters[:query].present?
        records = records.where_attributes_like(['projects.name', Project::PREFIXED_ID_SQL], @filters[:query])
      end

      if @filters[:members].present?
        records = records.joins(:user_assignments).where(user_assignments: { user_id: @filters[:members].values })
      end
      if @filters[:created_at_from].present?
        records = records.where('projects.created_at > ?',
                                @filters[:created_at_from])
      end
      records = records.where('projects.created_at < ?', @filters[:created_at_to]) if @filters[:created_at_to].present?
      if @filters[:archived_on_to].present?
        records = records.where('projects.archived_on < ?',
                                @filters[:archived_on_to])
      end
      if @filters[:archived_on_from].present?
        records = records.where('projects.archived_on > ?', @filters[:archived_on_from])
      end
      records
    end

    def filter_project_folder_records(records)
      records = records.archived if @params[:view_mode] == 'archived'
      records = records.active if @params[:view_mode] == 'active'
      records = records.where_attributes_like('project_folders.name', @filters[:query]) if @filters[:query].present?
      records = records.where_attributes_like('project_folders.name', @params[:search]) if @params[:search].present?
      records
    end

    def sort_records
      return unless @params[:order]

      sort = "#{order_params[:column]}_#{sort_direction(order_params)}"

      case sort
      when 'created_at_ASC'
        @records = @records.order(:created_at)
      when 'created_at_DESC'
        @records = @records.order(created_at: :desc)
      when 'name_ASC'
        @records = @records.order(:name)
      when 'name_DESC'
        @records = @records.order(name: :desc)
      when 'code_ASC'
        @records = @records.order(:id)
      when 'code_DESC'
        @records = @records.order(id: :desc)
      when 'archived_on_ASC'
        @records = @records.order(:archived_on)
      when 'archived_on_DESC'
        @records = @records.order(archived_on: :desc)
      when 'users_ASC'
        @records = @records.sort_by { |object| project_users_count(object) }
      when 'users_DESC'
        @records = @records.sort_by { |object| project_users_count(object) }.reverse!
      when 'updated_at_ASC'
        @records = @records.sort_by(&:updated_at).reverse!
      when 'updated_at_DESC'
        @records = @records.sort_by(&:updated_at)
      when 'comments_ASC'
        @records = @records.sort_by { |object| project_comments_count(object) }
      when 'comments_DESC'
        @records = @records.sort_by { |object| project_comments_count(object) }.reverse!
      end
    end

    def paginate_records
      @records = Kaminari.paginate_array(@records).page(@params[:page]).per(@params[:per_page])
    end

    def project_comments_count(object)
      project?(object) ? object.comments.count : -1
    end

    def project_users_count(object)
      project?(object) ? object.users.count : 0
    end

    def project?(object)
      object.instance_of?(Project)
    end
  end
end
