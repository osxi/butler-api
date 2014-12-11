class User < ActiveRecord::Base
  belongs_to :team
  has_many :time_entries
  has_and_belongs_to_many :projects
  has_many :tasks, through: :projects

  def name
    "#{first_name} #{last_name}"
  end
end
