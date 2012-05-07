class AddActiveToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :active, :string
  end

  def self.down
    remove_column :plans, :active
  end
end
