module FreshBooksApi
  class Staff < Client
    def all
      list_get_all(:staff, :staff_members, :member)
    end
  end
end
