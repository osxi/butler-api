namespace :time_tracking do
  desc 'Create/Update time entries from FreshBooks then update Trello card actuals. Date Format: [2014-10-12,2014-10-13]'
  task :update_in_range, [:from_day, :to_day] => [:environment] do |_t, args|
    from = (args[:from_day] && args[:from_day].to_date) || DateTime.now - 1.days
    to   = (args[:to_day]   && args[:to_day].to_date)   || DateTime.now

    Rake::Task['freshbooks:import_time_entries'].invoke(from, to)
    Rake::Task['trello:update_card_actuals'].invoke(from, to)
  end
end
