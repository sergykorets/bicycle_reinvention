class CreateDislikes < ActiveRecord::Migration[5.0]
  def change
    create_table :dislikes do |t|
      t.integer :author_id
      t.integer :bicycle_id
    end
  end
end
