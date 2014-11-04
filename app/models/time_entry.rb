class TimeEntry < ActiveRecord::Base
  def update_from_freshbooks(client)
    return unless fb_id.present?

    fb_entry = client.get(fb_id)['time_entry']

    %w(staff_id project_id staff_id).each do |key|
      send("fb_#{key}=", fb_entry[key])
    end

    %w(hours date notes).each do |key|
      send("#{key}=", fb_entry[key])
    end

    save
    self
  end
end
