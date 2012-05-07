class AddNoteToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :note, :text
  end

  def self.down
    remove_column :subscriptions, :note
  end
end
