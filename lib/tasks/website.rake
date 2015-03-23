namespace :website do
  desc 'Ping sites'
  task :ping_websites => :environment do
  	Website.all.each do |website|
  		website.ping_url
  	end
  end
end
