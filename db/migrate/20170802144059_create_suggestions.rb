class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.string :name
      t.text :content
      t.integer :category_id
      t.integer :author_id
      t.integer :bicycle_id
      t.boolean :approved
      t.timestamps
    end
  end
end
