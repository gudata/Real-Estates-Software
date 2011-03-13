SellDocument.all.each do |sell_document|
  begin
    sell_document.sell
  rescue
    puts "removing #{sell_document.id}"
    sell_document.destroy
  end
end.reject{true}

Sell.find_each do |sell|
  begin
    sell.address
  rescue
    sell.address = nil
    puts "fixing #{sell.id}"
    sell.save
    retry
  end
end.reject{true}
