class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :team
  has_many :time_entries
  has_and_belongs_to_many :projects
  has_many :tasks, through: :projects

  before_save :ensure_authentication_token!

  scope :managers, -> { where(manager: true) }

  delegate :name, to: :team, prefix: true, allow_nil: true

  def name
    "#{first_name} #{last_name}"
  end

  def ensure_authentication_token!
    self.authentication_token = generate_authentication_token if authentication_token.blank?
  end

  def hours_in_range(date_range)
    time_entries.where(date: date_range)
      .map(&:hours).inject(:+) || 0
  end

  def name_or_email
    self.try(:name) || self.try(:email) || "Unknown (fbid: #{self.fb_staff_id})"
  end

  class << self
    def try_name_from_fb_staff_id(id)
      user = User.find_by(fb_staff_id: id)
      user.try(:name) || 'Unknown Staff'
    end
  end

  private

  def generate_authentication_token
    self.authentication_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(authentication_token: random_token)
    end
  end
end
