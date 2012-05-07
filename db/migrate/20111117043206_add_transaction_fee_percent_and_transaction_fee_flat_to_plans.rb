class AddTransactionFeePercentAndTransactionFeeFlatToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :transaction_fee_percent, :decimal, :precision => 8, :scale => 4
    add_column :plans, :transaction_fee_flat, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :plans, :transaction_fee_flat
    remove_column :plans, :transaction_fee_percent
  end
end
