module FreshBooksApi
  class Staff < Client
    def all
      list_get_all(:staff, :staff_members, :member)
    end

    def import_all
      all.each do |staff|
        user            = User.find_or_create_by(fb_staff_id: staff['staff_id'])
        user.first_name = staff['first_name']
        user.last_name  = staff['last_name']
        user.email      = staff['email']

        if user.encrypted_password.blank?
          new_pass  = SecureRandom.urlsafe_base64(nil, false)
          user.password              = new_pass
          user.password_confirmation = new_pass
        end

        user.save! if user.new_record?
      end
    end
  end
end
