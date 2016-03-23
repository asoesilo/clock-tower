class User < ActiveRecord::Base
  has_secure_password
  has_many :projects
  has_many :time_entries
  has_many :statements

  belongs_to :location

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true

  validates :password_reset_token, uniqueness: true, if: :password_reset_token

  scope :hourly, -> { where(hourly: true) }
  scope :by_email, -> (email){ where('lower(email) = ?', email.downcase) }
  scope :active, -> { where(active: true) }
  scope :admins_accepting_emails, -> { where(is_admin: true, receive_admin_email: true) }

  after_create :send_email_invite

  attr_accessor :creator # virtual attribute

  def fullname
    "#{firstname} #{lastname}"
  end

  def as_json(options)
    {
      id: id,
      firstname: firstname,
      lastname: lastname,
      fullname: fullname,
      email: email
    }
  end

  private

  def send_email_invite
    UserMailer.user_invite(self, creator).deliver_now
  end

end
