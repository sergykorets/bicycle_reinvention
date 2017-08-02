class Category < ApplicationRecord

  has_many :bicycles, dependent: :destroy

  validates_uniqueness_of :name
  validates_presence_of :name

  before_save :capitalize_name

  def capitalize_name 
    self.name = self.name.titleize
  end

  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    else
      all
    end
  end
end
