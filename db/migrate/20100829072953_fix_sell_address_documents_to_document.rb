class FixSellAddressDocumentsToDocument < ActiveRecord::Migration
  def self.up
    Sell.find_each do |sell|
      puts "working on #{sell.id}"
      sell.sell_document.create_address_document if sell.sell_document.address_document.blank?
      sell.save(true)
    end
    puts ""
    puts "----------"
    puts "do db.repairDatabase();"

    Sell.find_each do |sell|
      puts "Bad sell.id #{sell.id}" if sell.sell_document.address_document.blank?
    end
    
  end

  def self.down
  end
end
