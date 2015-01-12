module API
  module V1
    class Reports < Grape::API
      include API::V1::Defaults

      before { authenticate! }

      resource :freshbooks do
        resource :time_entries do
          desc 'Return all time entries for given projects.'
          params do
            requires :project_ids,
                     type: Array,
                     desc: 'Freshbooks IDs of Projects to get back'

            optional :start_date,
                     type: Date,
                     default: Time.now - 2.years,
                     desc: 'Start date of query',
                     default: Time.now - 2.years

            optional :end_date,
                     type: Date,
                     default: Time.now,
                     desc: 'End date of query'

            optional :only_billable,
                     type: Boolean,
                     default: true,
                     desc: 'End date of query'
          end

          get do
            client = FreshBooksApi::TimeEntriesReporter.new(ENV['FB_API_URL'], ENV['FB_AUTH_TOKEN'])

            entries = client.report(project_ids: permitted_params[:project_ids],
                                    from: permitted_params[:start_date],
                                    to: permitted_params[:end_date],
                                    only_billable: permitted_params[:only_billable])

            { time_entries: entries }
          end
        end
      end

      resource :trello do
        resource :cards do
          desc 'Return all cards for given boards.'
          params do
            requires :board_ids,
                     type: Array,
                     desc: 'Trello IDs of boards to get back'
          end

          get do
            client = TrelloApi.new(ENV['TRELLO_KEY'], ENV['TRELLO_TOKEN'])
            cards  = client.report(board_ids: permitted_params[:board_ids])
            cards = cards.map do |card|
              card['created_at'] = card['created_at'].strftime('%m/%d/%Y %H:%M:%S')
              card
            end

            { cards: cards }
          end
        end
      end
    end
  end
end
