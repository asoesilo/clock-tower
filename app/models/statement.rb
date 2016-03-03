class Statement < ActiveRecord::Base
  has_many :time_entries
  belongs_to :user

  validates :from, presence: true
  validates :to, presence: true
  validates :user_id, presence: true
end
