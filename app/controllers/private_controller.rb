class PrivateController < ApplicationController
  rescue_from Mysql2::Error, with: :handle_mysql_error
  before_action :set_service
  before_action :set_tables

  def set_service
    session_id = session[:sid]
    logger.info("The current session id: #{session_id}")
    return redirect_to new_session_path unless session_id

    @service = Mysql::Service.new(session_id)
    redirect_to new_session_path unless @service.ok?
  end

  def set_tables
    @tables = @service.show_tables
  end

  def handle_mysql_error(exception)
    flash[:error] = exception.message
    redirect_to table_path(params[:table_name])
  end
end
