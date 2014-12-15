module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def auth_params
      @auth_user ||= create(:user)

      { authentication_token: @auth_user.authentication_token }
    end
  end
end
