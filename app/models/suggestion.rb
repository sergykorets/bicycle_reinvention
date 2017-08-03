class Suggestion < ApplicationRecord
  belongs_to :author
  belongs_to :bicycle

  #validates_uniqueness_of :bicycle_id

  def owner?(user)
    self.author == user
  end  
end