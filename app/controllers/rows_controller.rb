class RowsController < PrivateController
  def create
    table_name = params[:table_name]
    fields = params[:fields]

    @service.insert(table_name, fields)
    redirect_to table_path(table_name)
  end

  def destroy
    table_name = params[:table][:name]
    pk_field_name = params[:fields][:pk_field_name]
    pk_values = params[:fields][:pk_values]
    @service.delete(table_name, pk_field_name, pk_values)
    redirect_to table_path(table_name)
  end
end
