class Dislike < ApplicationRecord
  belongs_to :author
  belongs_to :bicycle

  validates_uniqueness_of :author_id, scope: :bicycle_id
end