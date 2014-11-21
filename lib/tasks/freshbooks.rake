namespace :freshbooks do
  desc 'Import all Freshbooks data'
  task :all => :environment do
    Rake::Task['freshbooks:import_staff'].invoke
    Rake::Task['freshbooks:import_time_entries'].invoke
  end

  desc "import time entries, date format [2014-10-12,2014-10-13]"
  task :import_time_entries, [:from_day, :to_day] => [:environment] do |t, args|

    from = (args[:from_day] && args[:from_day].to_date) || nil
    to   = (args[:to_day]   && args[:to_day].to_date)   || nil

    entries = FreshBooksApi::TimeEntries
              .new(ENV['FB_API_URL'], ENV['FB_AUTH_TOKEN'])
              .import_all(from: from, to: to)
    puts "Create/Updated #{entries.length} entry(ies)"
  end

  desc 'Import all staff into Poetic API.'
  task :import_staff => :environment do
    users = FreshBooksApi::Staff
            .new(ENV['FB_API_URL'], ENV['FB_AUTH_TOKEN'])
            .import_all
    puts "Processed #{users.length} staff."
  end
end
