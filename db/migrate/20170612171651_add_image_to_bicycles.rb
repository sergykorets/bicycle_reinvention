class AddImageToBicycles < ActiveRecord::Migration
  def up
    add_attachment :bicycles, :image
  end

  def down
    remove_attachment :bicycles, :image
  end
end