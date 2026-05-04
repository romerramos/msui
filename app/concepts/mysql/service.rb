class Mysql::Service
  def initialize(session_id)
    @connection = Mysql::Session::Service.connection_for(session_id)
  end

  def ok?
    @connection != nil
  end

  def tables
    current_tables = execute("SHOW TABLES").map { |row| row.values.first }
    current_tables.reduce({}) do  |result, table_name|
      result[table_name] = count(table_name)
      result
    end
  end

  def count(table_name)
    execute("SELECT COUNT(*) FROM #{table_name}").first.values.first
  end


  def field_names(table_name)
    result = execute "SHOW COLUMNS FROM #{table_name}"
    result.map { |row| row["Field"] }
  end

  def data(table_name)
    fields = field_names(table_name)
    pk_field = primary_key_field_name(table_name)
    Rails.logger.info("pk_field: #{pk_field}")
    execute "SELECT #{fields.join(", ")} FROM #{table_name} ORDER BY #{pk_field} DESC"
  end

  def update(table_name, field_name, field_value, original_row)
    condition = ""
    current = 0
    original_row.each do |field_name, value|
      condition += " AND " if current > 0
      condition += value.blank? ? "#{field_name} IS NULL" : "#{field_name} = '#{value}'"
      current += 1
    end
    execute "UPDATE #{table_name} SET #{field_name} = '#{field_value}' WHERE #{condition}"
  end

  def insert(table_name, fields)
    columns = "(#{fields.keys.join(", ")})"
    values = "(#{fields.values.map { |f| "'#{f}'" }.join(", ")})"
    query = "INSERT INTO #{table_name} #{columns} VALUES #{values}"
    execute query
  end

  private

  def primary_key_field_name(table_name)
    result = execute "SHOW KEYS FROM #{table_name} WHERE Key_name = 'PRIMARY'"
    result.first["Column_name"]
  end

  def execute(query)
    Rails.logger.info("[QUERY] #{query}")
    @connection.query query
  end
end
