require 'slack-notifier'

notifier  = Slack::Notifier.new 'https://hooks.slack.com/services/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'

namespace :snitch do
  desc "Alert when people forget to log time at end of day."
  task deficient_hours: :environment do
    date      = DateTime.now - 1.day
    from      = date.beginning_of_day
    to        = date.end_of_day
    message   = ''

    User.all.each do |user|
      user_hours = user.time_entries.where(date: from..to).map(&:hours).inject(:+) || 0

      if user_hours < 6
        message += "#{user.last_name}, #{user.first_name} has less than 6 hours logged\n"
      else
        message += "#{user.last_name}, #{user.first_name} logged a bunch of hours.\n"
      end
    end

    notifier.ping message
  end

  desc 'Manager Report'
  task :manager_report => :environment do
    User.where(manager: true).each do |manager|
      message += "Manager report for #{manager.last_name} " +
                 "#{manager.first_name}:\n"

      manager.team.users.each do |user|
        hours    = user.time_entries.map(&:hours).inject(:+)
        message += "- #{user.last_name}, #{user.first_name} has #{hours} hours logged."
      end
    end
  end
end
