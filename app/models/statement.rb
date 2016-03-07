class Statement < ActiveRecord::Base
  has_many :time_entries
  belongs_to :user

  validates :from, presence: true
  validates :to, presence: true
  validates :user_id, presence: true

  class << self
    def by_users(users)
      where(user_id: users)
    end

    def containing_date(date)
      where("statements.from <= ? AND statements.to >= ?", date, date)
    end
  end

  
end
