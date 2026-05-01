class FieldsController < PrivateController
  def update
    table_name = params[:table_name]
    field_name = params[:field_name]
    field_value = params[:field_value]
    original_row = JSON.parse(params[:original_row])

    @service.update(table_name, field_name, field_value, original_row)
    redirect_to table_path(table_name)
  end
end
