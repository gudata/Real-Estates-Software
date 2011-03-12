Contact.reset_counter_cache

SellDocument.all.each do |sell|
  contact = Contact.find_by_id(sell.contact_id)
  if contact.blank?
    puts "#{sell.contact_id} "
    sell.destroy
  end
end