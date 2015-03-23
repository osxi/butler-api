module ApplicationHelper

	def pretty_time(time)
		return '' if time.blank?
		time.in_time_zone('Central Time (US & Canada)').strftime( '%H:%M' )
	end
end
