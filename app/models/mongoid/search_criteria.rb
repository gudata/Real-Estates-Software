# = SearchCriteria
#
# Една оферта купува #Buy може да има много такива #SearchCriteria
#
class SearchCriteria
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ActiverecordPatch

  before_validation :fix_id_types
  before_validation :fix_terms_attributes
  
  @@keywords_property_types_cache = {}
  #  cache
  
  belongs_to_related :user
  embedded_in :buy, :inverse_of => :search_criterias
  
  validates_presence_of :property_type_id
  
  embeds_many :terms
  accepts_nested_attributes_for :terms, :allow_destroy => true

  #  field :property_type_id,  :type => Integer, :index => true
  referenced_in :property_type, :index => true, :class_name => "PropertyType"

  def hash_for_searching
    search_hash = {}

    terms_hash =  self.terms.collect do |term|
      term_hash = term.hash_for_searching
      Rails.logger.debug("Terms #{term_hash.inspect}")
      term_hash ? term_hash : nil
    end.compact


    unless terms_hash.empty?
      search_hash[:terms] = {"$all" => terms_hash}
    end

    unless self.property_type_id.blank?
#      search_hash["$elemMatch"] ||= {}
      search_hash[:property_type_id] = self.property_type_id
    end


    #    search_hash[:search_criterias] = {
    #      "$elemMatch" => {
    #        :terms => {"$all" => terms},
    #      }
    #    } unless terms.empty?
    #    search_hash[:search_criterias]["$elemMatch"][:property_type_id] = property_type_id unless property_type_id.blank?


    search_hash
  end

  # returns only those terms that are filled by the user
  def filled_terms
    self.terms.select {|t| !t.empty? }
  end

  # setup new terms based on keywords
  def set_new_terms(keywords)
    self.terms = keywords.collect do |keyword|
      keywords_property_type = keyword.keywords_property_type(property_type_id)
      self.terms << Term.new(
        :name => keyword.name,
        :tag => keyword.tag,
        :keyword_id => keyword.id,
        :patern => keyword.patern,
        :as => keyword.as,
        :position => position(property_type_id, keyword.id),
        :active => keyword.active,
        :kind_of_search => keyword.kind_of_search,
        
        :end_of_line => keywords_property_type.end_of_line,
        :style => keywords_property_type.style
      )
    end
  end
  
  # Сменя термите с нови базирани на keyword-и или терми
  def terms_from_keywords(keywords, property_type_id)
    set_terms_from_something keywords do |keyword|
      keywords_property_type = keyword.keywords_property_type(property_type_id)
      {
        :position => position(property_type_id, keyword.id),
        :end_of_line => keywords_property_type.end_of_line,
        :style => keywords_property_type.style,
      }
    end
  end

  # Ако намери стойности от старите терми ги запазва
  def terms_from_terms(terms)
    set_terms_from_something terms do |term|
      {
        :position => term.position,
        :end_of_line => term.end_of_line,
        :style => term.style,
      }
    end
  end

  def term tag
    terms.where(:tag => tag).first
  end


  def load_terms property_type_id
    keywords = Keyword.where(
      ["keywords_property_types.property_type_id = :property_type_id",
        {:property_type_id => property_type_id}
      ]
    ).
      includes(:keywords_property_types, :translations).
      order("keywords_property_types.position asc")

    self.terms_from_keywords(keywords, property_type_id)
  end

  
  private
  def set_terms_from_something terms_or_keywords
    old_terms_hash = self.terms.inject({}) do |hash, old_term|
      hash[old_term.tag] = old_term
      hash
    end

    self.terms.clear

    terms_or_keywords.each do |object|
      attributes = yield(object)

      if old_terms_hash.key?(object.tag)
        new_term  = old_terms_hash[object.tag]
        # update only the position of the new term
        new_term.position = attributes[:position]
      else
        new_term = Term.new(
          :name => object.name,
          :tag => object.tag,
          :keyword_id => object.id,
          :patern => object.patern,
          :as => object.as,
          :position => attributes[:position],
          :end_of_line => attributes[:end_of_line],
          :style => attributes[:style],
          :active => object.active,
          :kind_of_search => object.kind_of_search
        )
      end
      self.terms << new_term
    end
  end

  def position property_type_id, keyword_id
    unless @@keywords_property_types_cache.key? property_type_id
      @@keywords_property_types_cache[property_type_id] = {}
      KeywordsPropertyType.find(:all, :conditions => {:property_type_id => property_type_id}, :include => [:keyword]).each do |keywords_property_type|
        @@keywords_property_types_cache[property_type_id][keywords_property_type.keyword_id] = keywords_property_type
      end
    end
    
    return @@keywords_property_types_cache[property_type_id][keyword_id].position
  end

  protected
  def fix_terms_attributes
    self.terms.each do |term|
      term.fix_attributes
    end
  end
end