module SlackApi
  class Users < Client
    def info(user_id)
      self.class.get('/users.info',
                     query: @options[:query].merge(user: user_id))
    end

    def list
      self.class.get('/users.list', @options)
    end

    def import_all
      slack_users = list['members']

      slack_users.each do |slack_user|
        user = User.find_by_email(slack_user['profile']['email'])
        next if user.nil?
        user.slack_id = slack_user['id']
        user.save! if user.changed?
      end
    end
  end
end
