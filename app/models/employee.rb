class Employee < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :time_entries

  def name
    "#{first_name} #{last_name}"
  end
end
