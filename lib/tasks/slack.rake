namespace :slack do
  desc 'Import all Slack data'
  task all: [:environment, :import_users]

  desc 'Import Slack user_ids into Users.'
  task import_users: :environment do
    client = SlackApi::Users.new(ENV['SLACK_API_TOKEN'])
    client.import_all
  end
end
