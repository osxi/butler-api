
namespace :snitch do
  desc 'Alert when people forget to log time at end of day.'
  task deficient_hours: :environment do
    slack   = SlackApi::Chat.new(ENV['SLACK_API_TOKEN'])
    date    = DateTime.now
    from    = date.beginning_of_day
    to      = date.end_of_day
    message = ''

    User.all.each do |user|
      user_hours = user.time_entries.where(date: from..to).map(&:hours).inject(:+) || 0

      puts "#{user.name}: #{user_hours}"

      if user_hours < 6
        today   = Time.now.strftime('%Y-%m-%d')
        message = 'You have less than six hours logged in Freshbooks. ' \
                  'Please check your entries for today. ' \
                  "(https://poeticsystems.freshbooks.com/timesheet#date/#{today})"
        slack.post_message(channel: user.slack_id, text: message,
                           username: 'Butler')
      end
    end
  end

  desc 'Manager Report'
  task manager_report: :environment do
    slack = SlackApi::Chat.new(ENV['SLACK_API_TOKEN'])

    User.where(manager: true).each do |manager|
      message = "Manager report for #{manager.last_name} " \
                 "#{manager.first_name}:\n"

      manager.team.users.each do |user|
        yesterday  = (Time.now - 1.day).strftime('%m/%d/%Y')
        team       = user.team.name
        report_url = Rails.application.routes.url_helpers
                     .report_daily_url host: ENV['ROOT_URL']
        message   += "Here's yesterday's report for your team: " \
                   "#{report_url}?date=#{yesterday}&team=#{team}"
        slack.post_message(channel: user.slack_id, text: message,
                           username: 'Butler')
      end
    end
  end
end
