namespace :freshbooks do
  desc "import time entries, date format [2014-10-12,2014-10-13]"
  task :import_time_entries, [:from_day, :to_day] => [:environment] do |t, args|

    from = (args[:from_day] && args[:from_day].to_date) || nil
    to   = (args[:to_day]   && args[:to_day].to_date)   || nil

    client = FreshBooksApi::TimeEntries.new(ENV['FB_API_URL'], ENV['FB_AUTH_TOKEN'])

    entries = client.import_all(from: from, to: to)
    puts "Create/Updated #{entries.length} entry(ies)"
  end
end
