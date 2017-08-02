class CreateBicycles < ActiveRecord::Migration[5.0]
  def change
    create_table :bicycles do |t|
      t.string :name
      t.text :content
      t.string :slug

      t.timestamps
    end
    add_index :bicycles, :slug, unique: true
  end
end
