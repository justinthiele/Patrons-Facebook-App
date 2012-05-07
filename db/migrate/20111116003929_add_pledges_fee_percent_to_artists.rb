class AddPledgesFeePercentToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :pledges_fee_percent, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :artists, :pledges_fee_percent
  end
end
