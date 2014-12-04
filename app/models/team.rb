class Team < ActiveRecord::Base
  has_many :users
  has_many :time_entries, through: :users
end
