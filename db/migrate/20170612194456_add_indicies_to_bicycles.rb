class AddIndiciesToBicycles < ActiveRecord::Migration[5.0]
  def change
    add_column :bicycles, :author_id, :integer
    add_index :bicycles, :author_id
    add_column :bicycles, :category_id, :integer
    add_index :bicycles, :category_id
  end
end
