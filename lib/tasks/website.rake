namespace :website do
  desc 'Ping sites'
  task :ping_websites => :environment do
  	Website.all do |website|
  		website.ping_now
  	end
  end
end
