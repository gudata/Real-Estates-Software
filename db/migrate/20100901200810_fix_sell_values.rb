class FixSellValues < ActiveRecord::Migration
  def self.up
    Sell.all.each{|s| s.save}
  end

  def self.down
  end
end