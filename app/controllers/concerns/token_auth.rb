module TokenAuth
  extend ActiveSupport::Concern

  included do
    def authenticated
      auth_token = params[:authentication_token]
      auth_token && @user = User.find_by(authentication_token: auth_token)
    end

    def authenticate!
      unauthorized unless authenticated
    end

    def unauthorized
      raise NoMethodError, "#unauthorized not defined"
    end
  end
end
