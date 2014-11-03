module API
  module V1
    class TimeEntries < Grape::API
      include API::V1::Defaults

      resource :time_entries do
        desc 'Freshbooks time entries'
        params do
          requires :api_url, type: String, desc: 'Freshbooks API URL'
          requires :auth_token, type: String, desc: 'Freshbooks Auth Token'
          optional :trello_key, type: String, desc: 'Trello Key'
          optional :trello_token, type: String, desc: 'Trello Token'

          optional :time_entry, type: Hash do
            requires :project_id, type: Integer
            requires :task_id, type: Integer
            requires :staff_id, type: Integer
            requires :hours, type: Float
            requires :notes, type: String
            requires :date, type: Date
            optional :card_id, type: String
          end
        end
        post do
          TimeEntryCreator.new(permitted_params).create
        end
      end
    end
  end
end
