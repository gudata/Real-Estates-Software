class Alert
  def initialize 
    @errors = false
    @messages = []
  end

  def check
    if Office.active.count == 0 
      @messages << "Няма активни офиси. Направете и маркирайте активни офиси."
    end
    
    if Team.active.count == 0
      @messages << "Няма активни екипи. Направете и маркирайте активни офиси."
    end
    @messages
  end
end
