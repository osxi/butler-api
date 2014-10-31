module FreshBooksApi
  class Tasks < Client
    def all
      list_get_all(:task, :tasks, :task)
    end
  end
end
