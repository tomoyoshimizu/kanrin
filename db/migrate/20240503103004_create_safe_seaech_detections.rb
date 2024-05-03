class CreateSafeSeaechDetections < ActiveRecord::Migration[6.1]
  def change
    create_table :safe_seaech_detections do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :adult
      t.integer :spoof
      t.integer :medical
      t.integer :violence
      t.integer :racy

      t.timestamps
    end
  end
end
