class TablesController < PrivateController
  def show
    @table_name = params[:id]
    @fields = @service.field_names(@table_name)
    @data = @service.data(@table_name)
  end
end
