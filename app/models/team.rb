class Team < ActiveRecord::Base
  has_and_belongs_to_many :employees
  has_many :time_entries, through: :employees
end
