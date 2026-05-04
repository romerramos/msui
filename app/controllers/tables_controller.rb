class TablesController < PrivateController
  def show
    @table = @service.find_table_by_name(params[:id])
  end
end
