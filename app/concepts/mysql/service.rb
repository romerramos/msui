class Mysql::Service
  def initialize(session_id)
    @connection = Mysql::Session::Service.connection_for(session_id)
  end

  def ok?
    @connection != nil
  end

  def tables
    current_tables = @connection.query("SHOW TABLES").map { |row| row.values.first }
    current_tables.reduce({}) do  |result, table_name|
      result[table_name] = count(table_name)
      result
    end
  end

  def count(table_name)
    @connection.query("SELECT COUNT(*) FROM #{table_name}").first.values.first
  end


  def field_names(table_name)
    result = @connection.query("SHOW COLUMNS FROM #{table_name}")
    result.map { |row| row["Field"] }
  end

  def data(table_name)
    fields = field_names(table_name)
    @connection.query("SELECT #{fields.join(", ")} FROM #{table_name};")
  end

  def update(table_name, field_name, field_value, original_row)
    condition = ""
    current = 0
    original_row.each do |field_name, value|
      condition += "AND " if current > 0
      condition += "#{field_name} = '#{value}'"
      current += 1
    end
    @connection.query("UPDATE #{table_name} SET #{field_name} = '#{field_value}' WHERE #{condition}")
  end
end
