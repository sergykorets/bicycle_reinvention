# == Schema Information
#
# Table name: bicycles
#
#  id                 :integer          not null, primary key
#  name               :string
#  content            :text
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  author_id          :integer
#  published          :boolean
#  published_at       :datetime
#

class Bicycle < ApplicationRecord

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :author
  has_many :comments, dependent: :destroy
  belongs_to :category
  has_many :dislikes, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :content

  scope :most_recent, -> { order(published_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :disliked, -> { joins(:dislikes).where('dislikes.author_id is not null') }
  scope :without_disliked, -> { where('id NOT IN (?)', @bicycles) }
  

  has_attached_file :image, styles: { medium: "700x400>", thumb: "350x200>" }, default_url: "Flag_missing.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_attachment_size :image, :in => 0.megabytes..2.megabytes

  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    else
      all
    end
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def display_day_published
    if published_at.present?
  	  published_at.strftime('%-b %-d, %-Y')
    else
      "Not published"
    end
  end

  def owner?(user)
    self.author == user
  end
end
