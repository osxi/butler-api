module FreshBooksApi
  class Tasks < Client
    def all
      list_get_all(:task, :tasks, :task)
    end

    def import_all
      all.each do |fb_task|
        task = Task.find_or_create_by(fb_task_id: fb_task['task_id'])
        task.name       = fb_task['name']
        task.fb_task_id = fb_task['task_id']
        task.save! if task.changed?
      end
    end
  end
end
