class User < ActiveRecord::Base
  belongs_to :team
  has_many :time_entries

  def name
    "#{first_name} #{last_name}"
  end
end