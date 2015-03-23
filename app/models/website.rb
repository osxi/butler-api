class Website < ActiveRecord::Base
	require 'net/http'

	validates_presence_of :name, :url

	def ping_url
		http = Net::HTTP.new(url,80)
		response = http.request_get('/')
		code = response.code
		
		live = code == '200' ? true : false
		
		self.update_column(:live, live)
		self.update_column(:ping, Time.now)
	end
end
