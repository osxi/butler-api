class Snitch
  def initialize(slack_api_token, date)
    @slack = SlackApi::Chat.new(slack_api_token)
    @dates = OpenStruct.new({
      today:      date,
      yesterday:  date - 1.day,
      all_day:    date.beginning_of_day..date.end_of_day
    })
  end

  def send_deficient_hours_report
    User.all.each do |user|
      user_hours = user.hours_in_range(@dates.all_day)

      puts "#{user.name}: #{user_hours}"

      message_if_deficient user.slack_id, user_hours
    end
  end

  def send_manager_report
    User.managers.each do |user|
      post_message user.slack_id, manager_message(user.team.name)
    end
  end

  private

  def message_if_deficient(slack_id, user_hours)
    if user_hours < ENV['SNITCH_MINIMUM_HOURS'].to_i
      post_message slack_id, deficient_message
    end
  end

  def deficient_message
    today = @dates.today.strftime('%Y-%m-%d')
    "You have less than six hours logged in Freshbooks. " \
    "Please check your entries for today. " \
    "https://poeticsystems.freshbooks.com/timesheet#date/#{today}"
  end

  def manager_message(team)
    yesterday  = @dates.yesterday.strftime('%m/%d/%Y')
    "Here's yesterday's report for your team: " \
    "#{manager_report_url}?date=#{yesterday}&team=#{team}"
  end

  def post_message(slack_id, message)
    @slack.post_message(channel: slack_id, text: message, username: 'Butler')
  end

  def manager_report_url
    @manager_report_url ||= Rails.application.routes.url_helpers
                            .report_daily_url host: ENV['ROOT_URL']
  end
end
