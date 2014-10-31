module API
  module V1
    class TimeEntries < Grape::API
      include API::V1::Defaults

      resource :time_entries do
        desc 'Freshbooks time entries'
        params do
          requires :api_url, type: String, desc: 'Freshbooks API URL'
          requires :auth_token, type: String, desc: 'Freshbooks Auth Token'

          optional :time_entry, type: Hash do
            requires :project_id, type: Integer
            requires :task_id, type: Integer
            requires :staff_id, type: Integer
            requires :hours, type: Float
            requires :notes, type: String
            requires :date, type: Date
          end
        end
        post do
          api_url    = permitted_params[:api_url]
          auth_token = permitted_params[:auth_token]

          client = FreshBooksApi::TimeEntries.new(api_url, auth_token)

          client.create(permitted_params[:time_entry])
        end
      end
    end
  end
end
