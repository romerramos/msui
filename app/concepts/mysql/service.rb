class Mysql::Service
  def initialize(session_id)
    @connection = Mysql::Session::Service.connection_for(session_id)
  end

  def ok?
    @connection != nil
  end

  def find_table_by_name(table_name)
    table = show_tables.select { |table| table.name == table_name }.first
    table.fields = get_fields(table_name)
    table.rows = get_rows(table_name)
    pk_field_name = primary_key_field_name(table_name)
    table.pk_field = table.fields.select { |f| f.name == pk_field_name }.first
    table
  end

  def show_tables
    tables = execute("SHOW TABLES").map { |row| row.values.first }
    tables.map do |table_name|
      table = Table.new
      table.name = table_name
      table.count = count(table_name)
      table
    end
  end

  def count(table_name)
    execute("SELECT COUNT(*) FROM #{table_name}").first.values.first
  end

  def update(table_name, field_name, field_value, original_row)
    fields = get_fields(table_name)
    pk_field = primary_key_field_name(table_name)
    pk_value = original_row[pk_field]

    condition = "#{pk_field} = #{pk_value}"

    field = fields.select { |f| f.name == field_name }.first
    execute "UPDATE #{table_name} SET #{field_name} = #{safe_value(field, field_value)} WHERE #{condition}"
  end

  def insert(table_name, fields)
    columns = "(#{fields.keys.join(", ")})"
    values = "(#{fields.values.map { |f| "'#{f}'" }.join(", ")})"
    query = "INSERT INTO #{table_name} #{columns} VALUES #{values}"
    execute query
  end

  def delete(table_name, pk_field_name, pk_values)
    execute "DELETE FROM #{table_name} WHERE #{pk_field_name} IN (#{pk_values.join(", ")})"
  end

  private

  def safe_value(field, value)
    safe_value = value
    if field.type.include?("text") || field.type.include?("varchar")
      safe_value = "'#{value}'"
    else
      safe_value = value
    end
    safe_value = "NULL" if value.blank?
    safe_value
  end

  def safe_equal(field, value)
    value.blank? ? "#{field.name} IS NULL" : "#{field.name} = #{safe_value(field, value)}"
  end

  def get_fields(table_name)
    result = execute "SHOW COLUMNS FROM #{table_name}"
    result.map do |row|
      field = Field.new
      field.name = row["Field"]
      field.required = row["Null"] == "NO"
      field.type = row["Type"]
      field.pk = row["Key"] == "PRI"
      field
    end
  end

  def get_rows(table_name)
    fields = get_fields(table_name)
    field_names = fields.map { |f| f.name }
    pk_field = primary_key_field_name(table_name)
    result = execute "SELECT #{field_names.join(", ")} FROM #{table_name} ORDER BY #{pk_field} DESC"

    result.map do |query_row|
      row = Row.new
      row.items = query_row.map do |query_item|
        item = Item.new
        item.field = fields.select { |field| field.name == query_item.first }.first
        item.value = query_item.last
        item
      end
      row
    end
  end

  def primary_key_field_name(table_name)
    result = execute "SHOW KEYS FROM #{table_name} WHERE Key_name = 'PRIMARY'"
    result.first["Column_name"]
  end

  def execute(query)
    Rails.logger.info("[QUERY] #{query}")
    @connection.query query
  end
end
