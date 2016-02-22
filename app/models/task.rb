class Task < ActiveRecord::Base
  belongs_to :creator, class_name: :User, foreign_key: "user_id"
  
  validates :name, presence: true, uniqueness: true

  def as_json(options)
    {
      id: id,
      name: name,
      creator: creator.as_json(options)
    }
  end
end
