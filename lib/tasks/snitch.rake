namespace :snitch do
  desc 'Alert when people forget to log time at end of day.'
  task deficient_hours: :environment do
    Snitch.new(ENV['SLACK_API_TOKEN'], Time.now).user
  end

  desc 'Manager Report'
  task manager_report: :environment do
    Snitch.new(ENV['SLACK_API_TOKEN'], Time.now).manager
  end
end
