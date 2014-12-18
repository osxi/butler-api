class Snitch
  def initialize(slack_api_token, date)
    @slack = SlackApi::Chat.new(slack_api_token)
    @dates = OpenStruct.new({
      today: date,
      yesterday: date - 1.day,
      from: date.beginning_of_day,
      to: date.end_of_day
    })
  end

  def user
    User.all.each do |user|
      user_hours = user.time_entries.where(date: @dates.from..@dates.to)
                   .map(&:hours).inject(:+) || 0

      puts "#{user.name}: #{user_hours}"

      if user_hours < 6
        today   = @dates.today.strftime('%Y-%m-%d')
        message = 'You have less than six hours logged in Freshbooks. ' \
                  'Please check your entries for today. ' \
                  "https://poeticsystems.freshbooks.com/timesheet#date/#{today}"
        @slack.post_message(channel: user.slack_id, text: message,
                            username: 'Butler')
      end
    end
  end

  def manager
    User.where(manager: true).each do |user|
      yesterday  = @dates.yesterday.strftime('%m/%d/%Y')
      team       = user.team.name
      report_url = Rails.application.routes.url_helpers
                   .report_daily_url host: ENV['ROOT_URL']
      message    = "Here's yesterday's report for your team: " \
                   "#{report_url}?date=#{yesterday}&team=#{team}"
      @slack.post_message(channel: user.slack_id, text: message,
                          username: 'Butler')
    end
  end
end
