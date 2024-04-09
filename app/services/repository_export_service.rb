# frozen_string_literal: true

class RepositoryExportService
  def initialize(file_type, rows, columns, user, repository, handle_name_func = nil, in_module: false, empty_export: true)
    @file_type = file_type
    @user = user
    @rows = rows
    @columns = columns
    @repository = repository
    @handle_name_func = handle_name_func
    @in_module = in_module
    @empty_export = empty_export
  end

  def export!
    case @file_type
    when :csv
      file_data = RepositoryCsvExport.to_csv(@rows, @columns, @user, @repository, @handle_name_func, @in_module, @empty_export)
    when :xlsx
      file_data = RepositoryXlsxExport.to_xlsx(@rows, @columns, @user, @repository, @handle_name_func, @in_module)
    end

    file_data
  end
end
