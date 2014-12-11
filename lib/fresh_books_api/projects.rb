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

        # Touch tasks
        fb_project['tasks']['task'].each do |task|
          if Task.where(fb_task_id: task['task_id']).blank?
            project.tasks.create(fb_task_id: task['task_id'])
          end
        end

        # Associate users
        fb_project['staff']['staff'].each do |fb_staff|
          user = User.find_by_id(fb_staff[1])
          if user.present? && !project.users.include?(user)
            project.users << user if user.present?
          end
        end

        project.save! if project.changed?
      end
    end
  end
end
