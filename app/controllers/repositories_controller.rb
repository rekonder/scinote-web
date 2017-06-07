class RepositoriesController < ApplicationController
  before_action :load_vars, only: :index
  before_action :check_view_all_permissions, only: :index
  before_action :generate_zip, only: :export_repository

  def index
    render('repositories/index')
  end

  # AJAX actions
  def repository_table_index
    @repository = Repository.find_by_id(params[:repository_id])
    if @repository.nil? || !can_view_repository(@repository)
      render_403
    else
      respond_to do |format|
        format.html
        format.json do
          render json: ::RepositoryDatatable.new(view_context,
                                                 @repository,
                                                 nil,
                                                 current_user)
        end
      end
    end
  end

  def export_repository
    if params[:row_ids] && params[:header_ids]
      generate_zip
    else
      flash[:alert] = t('zip_export.export_error')
    end
    redirect_to :back
  end

  private

  def load_vars
    @team = Team.find_by_id(params[:team_id])
    render_404 unless @team
    @repositories = @team.repositories.order(created_at: :asc)
  end

  def check_view_all_permissions
    render_403 unless can_view_team_repositories(@team)
  end

  def generate_zip
    zip = ZipExport.create(user: current_user)
    zip.generate_exportable_zip(
      current_user,
      to_csv(RepositoryRow.where(id: params[:row_ids]), params[:header_ids]),
      :repositories
    )
  end

  def to_csv(rows, headers)
    require 'csv'

    # Parse headers (magic numbers should be refactored - see
    # sample-datatable.js)
    header_names = []
    headers.each do |header|
      if header == '-1'
        header_names << I18n.t("repositories.table.row_name")
      elsif header == '-2'
        header_names << I18n.t('repositories.table.added_by')
      elsif header == '-3'
        header_names << I18n.t('repositories.table.added_on')
      else
        rc = RepositoryColumn.find_by_id(header)
        if rc
          header_names << rc.name
        else
          header_names << nil
        end
        # header_names << rc ? rc.name : nil
      end
    end

    CSV.generate do |csv|
      csv << header_names
      #sample_row = []
      #rows.each do |row|
      #  headers.each do |header|
      #    if header == '-1'
      #      sample_row << row.name
          #elsif header == '-2'
          #  sample_row << row.created_by.full_name
          #elsif header == '-3'
          #  sample_row << I18n.l(row.created_at, format: :full)
          #else
            #rc = RepositoryColumn.find_by_id(header)
            #if rc
            #  cell_id = RepositoryCell.where(
            #    repository_row_id: row,
            #    repository_header_id: header
            #  ).id
            #  if rc.data_type == 'date'
            #    rv = RepositoryDateValue.where(repository_cell_id: cell_id).take
            #  else
            #    rv = RepositoryTextValue.where(repository_cell_id: cell_id).take
            #  end
            #  sample_row << rv ? rv.value : nil
            #else
            #  sample_row << nil
            #end
        #  end
        #end
      #end
      #csv << sample_row
    end
  end
end
