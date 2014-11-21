class Team < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :time_entries, through: :users
end
