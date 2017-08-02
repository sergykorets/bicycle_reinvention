class AddPublishedToBicycles < ActiveRecord::Migration[5.0]
  def change
    add_column :bicycles, :published, :boolean
    add_column :bicycles, :published_at, :datetime
  end
end
