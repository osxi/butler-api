module API
  module V1
    class Projects < Grape::API
      include API::V1::Defaults

      resource :projects do
        desc 'Return all projects.'
        params do
          requires :api_url, type: String, desc: 'Freshbooks API URL'
          requires :auth_token, type: String, desc: 'Freshbooks Auth Token'
        end
        get do
          api_url    = permitted_params[:api_url]
          auth_token = permitted_params[:auth_token]

          FreshBooksApi::Projects.new(api_url, auth_token).all
        end
      end
    end
  end
end
