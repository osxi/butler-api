class Project < ActiveRecord::Base
  has_many :tasks
  has_and_belongs_to_many :users
end
