module FreshBooksApi
  class Projects < Client
    def all
      list_get_all(:project, :projects, :project)
    end

    def import_all
      all.each do |fb_project|
        project = Project.find_or_create_by(fb_project_id: fb_project['project_id'])
        project.name        = fb_project['name']
        project.description = fb_project['description']

        build_tasks project, fb_project
        build_staff project, fb_project

        project.save! if project.changed?
      end
    end

    private

    def build_tasks(project, fb_project)
      fb_project['tasks']['task'].each do |task|
        find_or_add_task(get_task_id(task), project)
      end
    end

    def get_task_id(task)
      if task.is_a? Array
        task[1]
      else
        task['task_id']
      end
    end

    def find_or_add_task(task_id, project)
      if Task.find_by(fb_task_id: task_id).blank?
        project.tasks.new(fb_task_id: task_id)
      end
    end

    def build_staff(project, fb_project)
      fb_project['staff']['staff'].each do |fb_staff|
        find_or_add_staff(fb_staff[1].to_i, project)
      end
    end

    def find_or_add_staff(staff_id, project)
      user = User.find_by(fb_staff_id: staff_id)
      if user.present? && !project.users.include?(user)
        project.users << user
      end
    end
  end
end
