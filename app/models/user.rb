class User < ActiveRecord::Base
  has_secure_password
  has_many :projects

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true, email: true

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
end
