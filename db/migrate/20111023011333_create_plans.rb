class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :artist_id

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
