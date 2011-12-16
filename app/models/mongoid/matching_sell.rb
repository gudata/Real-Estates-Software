# = MatchingSell
#
# Държи много критерии и съответните им резултати от sell_documents
# използва се за да се намерят оферти продава - #Sell(s) към дадена оферта търси #Buy
#
# В пълният си вид към един MatchingSell могат да се добавят много критерии:
#    @matching_sell = MatchingSell.new
#    @matching_sell << @search_criteria1
#    @matching_sell << @search_criteria2
#
#    @matching_sell[@search_criteria1] -> връща MongoID Criterion
#    
# ако се полза за просто търсене тогава
#
# m = MatchingSell.new
# m << Buy.make()
# m.sell_documents
#
class MatchingSell

  delegate \
    :first,
    :each,
    :last,
    :size,
    :empty?,
    :to => :sell_documents
  
  attr :sell_documents, true
  attr :search_criteria_hash, false
  attr :presentation_object, false

  def count
    merged_results.count
  end

  def initialize
    @sell_documents = []
    @search_criteria_hash = {}
    @presentation_object = nil
  end

  # подготвя на база sell нов mongoid обект за търсене за документи

  def add(object, merge_with_last=false)
    case object
    when Hash
      object.each do |key, value|
        with_criteria(object, merge_with_last) do |sell_document|
          sell_document.where(key => value) unless value.blank?
        end
      end
    when Buy
      @presentation_object ||= object
      object.search_criterias.each do |search_criteria|
        self.add(search_criteria)
      end
    when SearchCriteria
      with_criteria(object, merge_with_last) do |sell_document|
        sell_document.where object.buy.hash_for_searching
        sell_document.where object.hash_for_searching
      end
    end
  end

  alias :<< :add
  
  def [] search_criteria
    @search_criteria_hash[search_criteria]
  end

  def merged_results
    # TODO - maybe this must be paginated !!!
    merged_criteria = SellDocument.criteria

    @sell_documents.each do |criteria|
      merged_criteria + criteria
    end
    
    merged_criteria
  end


  private
  def with_criteria object, merge_with_last
    @presentation_object ||= object

    if merge_with_last and @sell_documents.size > 0
      sell_document = @sell_documents.last
    else
      sell_document = SellDocument.criteria
    end

    yield(sell_document)

    if !merge_with_last
      @sell_documents << sell_document
      @search_criteria_hash[object] = sell_document
    end
  end
end

__END__

db.sell_documents.find({"sell_id" :"975"})


use re_development
db.sell_documents.find({ $or: [{"address_document.district_id": "1", "address_document.street": "Feil Summit"}, {"address_document.street": "Keenan Creek"}]}, {"address_document":1})


 