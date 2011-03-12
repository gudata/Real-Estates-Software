class OfferObserver < ActiveRecord::Observer
  observe :sell, :project, :buy

  # we have to do this manually in Buy - ugly but true
  
  def after_save record
    record.contact.make_contact_client(record, true)
    record.contact.calc_offers(record)
  end

  def after_destroy record
    record.contact.make_contact_client(record, false) unless record.contact.has_offers_for_user(record.user)
    record.contact.calc_offers(record)
  end

end
