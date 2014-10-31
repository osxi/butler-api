module FreshBooksApi
  class Projects < Client
    def all
      list_get_all(:project, :projects, :project)
    end
  end
end
