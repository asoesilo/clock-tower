class Project < ActiveRecord::Base
  belongs_to :creator, class_name: :User, foreign_key: "user_id"

  validates :name, presence: true
  validates :creator, presence: true
end
