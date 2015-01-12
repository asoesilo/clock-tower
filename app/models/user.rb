class User < ActiveRecord::Base
  has_secure_password
  has_many :projects
  has_many :time_entries

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  scope :hourly, -> { where(hourly: true) }

  def fullname
    "#{firstname} #{lastname}"
  end

  def rate_for(task, holiday = false)
    return nil unless hourly?
    if secondary_rate? && task.apply_secondary_rate?
      rate = self.secondary_rate
    else
      rate = self.rate
    end
    holiday ? rate.to_f * holiday_rate_multiplier : rate.to_f
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
end
