class ApplicationController < ActionController::Base
  include TokenAuth

  protect_from_forgery with: :exception

  before_action :authenticate!

  def unauthorized
    render layout: false, file: "public/401.html", status: 401
  end
end
