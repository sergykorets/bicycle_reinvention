class Comment < ApplicationRecord
  belongs_to :bicycle
  belongs_to :author

  validates_presence_of :content
  validates_presence_of :author_id

  scope :desc, -> { order(created_at: :desc) }

  def owner?(user)
  	self.author == user
  end
end
