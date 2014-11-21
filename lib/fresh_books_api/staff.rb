module FreshBooksApi
  class Staff < Client
    def all
      list_get_all(:staff, :staff_members, :member)
    end

    def import_all
      all_staff = all

      all_staff.each do |staff|
        employee = Employee.find_or_create_by(fb_staff_id: staff['staff_id'])
        employee.first_name ||= staff['first_name']
        employee.last_name  ||= staff['last_name']
        employee.email      ||= staff['email']

        employee.save! if employee.changed?
      end
    end
  end
end
