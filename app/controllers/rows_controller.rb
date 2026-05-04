class RowsController < PrivateController
  def create
    table_name = params[:table_name]
    fields = params[:fields]

    @service.insert(table_name, fields)
    redirect_to table_path(table_name)
  end
end
