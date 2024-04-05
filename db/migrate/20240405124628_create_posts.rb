class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :project, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :working_minutes

      t.timestamps
    end
  end
end
