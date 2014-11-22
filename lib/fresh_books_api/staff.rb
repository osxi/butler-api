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
        user.save! if user.changed?
      end
    end
  end
end
