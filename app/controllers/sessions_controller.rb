class SessionsController < ApplicationController
  layout "sessions"
  def new
  end

  def create
    service = Mysql::Session::Service.new(
      host: params[:host],
      username: params[:username],
      password: params[:password],
      port: params[:port],
      database: params[:database]
    )

    session_id = session[:sid] = SecureRandom.uuid
    service.connect(session_id)
    redirect_to home_path
  end
end
