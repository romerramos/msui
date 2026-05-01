class Mysql::Session::Service
  def initialize(host:, username:, password:, port:, database:)
    @mysql_connection = Mysql2::Client.new(
      host: host,
      username: username,
      password: password,
      port: port,
      database: database
    )
  end

  def connect(session_id)
    MYSQL_CONNECTIONS[session_id] = @mysql_connection
    Rails.logger.info("Attached session_id: #{session_id} to connection #{@mysql_connection.inspect}")
  end

  def self.connection_for(session_id)
    connection = MYSQL_CONNECTIONS[session_id]
    Rails.logger.info("Get connection #{connection} for session_id: #{session_id}")
    connection
  end

  def self.disconnect(session_id)
    MYSQL_CONNECTIONS.delete(session_id)
  end
end
