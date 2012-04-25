class Term
  include Mongoid::Document
  #  include MongoTranslation
  include Mongoid::I18n
  include Mongoid::ActiverecordPatch

  before_validation :fix_id_types
  before_save :fix_attributes
  
  embedded_in :search_criteria, :inverse_of => :terms

  field :keyword_id, :type => Integer, :index => true
  localized_field :name, :type => String
  
  field :patern
  field :as
  # RAILS 3 fixme with all translates
  # da smenq id-tata
  #
  field :active, :type => Boolean, :default => true

  
  # http://groups.google.com/group/mongomapper/browse_thread/thread/30fdba4ec92a74f7/798ebaa2a0badd7b?lnk=gst&q=query#798ebaa2a0badd7b
  field :tag

  # range searches
  field :from, :type => Integer, :index => true
  field :to, :type => Integer, :index => true
  
  field :from_date, :type => Time, :index => true
  field :to_date, :type => Time, :index => true

  # exact searches and ranges
  # това се кешира в selldocument
  field :value, :type => Integer, :index => true

  # multiple / nomeclature search
  field :values, :type => Array, :index => true, :default => []
  #  has_many :values

  # sort possition
  field :position, :type => Integer, :index => true
  field :end_of_line, :type => Boolean
  field :style # css kind of

  validates_numericality_of  :position, :value, :from, :to

  # sort possition
  field :kind_of_search

  def empty?
    value.blank? and from.blank? and to.blank? and from_date.blank? and to_date.blank? and (values.blank? or values.empty?)
  end

  def filled_keys
    [:from, :to, :value, :values, :from_date, :to_date].select{|v| v if !self.send("#{v}").blank?}
  end



  def hash_for_searching
    clause   = {}

    clause[:values] = {'$in' =>  values} unless (values.blank? || values.empty?)


    range = {}
    range['$gte'] = from if (!from.blank?)
    range['$lte'] = to if (!to.blank?)
    clause[:value] = range if !(from.blank? and to.blank?)

    clause[:value] = value if !value.blank?

    return false if clause.values.empty?

    clause[:tag] = tag

    {'$elemMatch' => clause}
  end


  # when searching in 'from - to' intervals
  # тука трябва да се получи точното търсене
  # 
  # Чистият вариант който не включва интервали: 
  #    db.buys.find({
  #        'search_criterias.terms': {
  #          '$elemMatch': {
  #            // Варианта в който сме вътре
  #            'from': {'$gte': from },
  #            'to': {'$lte': to},
  #          }
  #        }
  #      }, {'search_criterias.terms.from': 1,'search_criterias.terms.to': 1}
  #    );
  def hash_for_searching_ranged
    raise 'not supported search in values' if !(values.blank? || values.empty?)
    raise 'not supported search for value' if !value.blank?

    term_criteria = {}
    unless from.blank?
      term_criteria['from'] = {}
      term_criteria['from']['$gte'] = from
    end

    unless to.blank?
      term_criteria['to'] = {}
      term_criteria['to']['$lte'] = to
    end
    
    return nil if from.blank? and to.blank?
      
    Rails.logger.debug "strict hash for #{tag} #{term_criteria}"
    Rails.logger.debug term_criteria.inspect
    term_criteria[:tag] = tag
    {'$elemMatch' => term_criteria}

  end


  # Вариант който включва интервали:
  #  примера е валиден от $not частта
  #
  #  Варианта с OR
  #
  #  from = 2
  #  to = 14
  #
  #  db.buys.find({
  #      'search_criterias.terms': {
  #        '$elemMatch': {
  #          '$not': {
  #            $or: [
  #              {
  #                'from': {'$lt': from},
  #                'from': {'$gt': to},
  #              },
  #              {
  #                'to': {'$gt': to},
  #                'to': {'$lt': from}
  #              }
  #            ]
  #          }
  #        }
  #      }
  #    },
  #    {'search_criterias.terms.from': 1,'search_criterias.terms.to': 1}
  #  );

  
  def hash_for_searching_ranged_loose_ends
    raise 'not supported search in values' if !(values.blank? || values.empty?)
    raise 'not supported search for value' if !value.blank?

    term_criteria = {}
    term_criteria[:tag] = tag
    #    a_max = [from, to].max
    #    b_min = [from, to].min

    a = from
    b = to



    term_criteria['$or'] = [
      {'from' => {'$lte' => a}, 'to' => {'$gte' => b}}, # from---a=======b---to
      {'from' => { '$gte' => a}, 'to' => {'$lte' => b}}, # a---from=====to---b
      {'from' => { '$gte' => a, '$lte' => b}, 'to' => {'$gte' => b}}, # from---a=======to~~~b
      {'from' => { '$lte' => a}, 'to' => {'$gte' => a, '$lte' => b}}, # a~~~from=======b---to
    ]
  

    Rails.logger.debug "Loose hash for #{tag} #{term_criteria}"
    Rails.logger.debug term_criteria.inspect
    {'$elemMatch' => term_criteria}
  end
  
  def <=> el
    self.position <=> el.position
  end
  
  def fix_attributes
    if self.from and self.to and self.from.to_i > self.to.to_i
      self.from, self.to = self.to, self.from
    end
    from_date, to_date = to_date, from_date if from_date and to_date and  from_date > to_date

    values.map!{|v| v.to_i } unless values.blank?
  end

  def can_do_full_interval?
    !(to.blank? or from.blank?)
  end
end


__END__
# Започваме да говорим. ..а-то трябва да е по малко от from-a
# b-то трябва дае по-голямо от ...
#

db.buys.find({ offer_type_id: 1,
    status_id: { $in: [ 1, 4, 5, 6, 7 ] },
    search_criterias: {
      $elemMatch: {
        terms: {
          $all: [
            {
              $elemMatch: {
                tag: "price",
                $or: [
                  //                  {from: { $lte: 80001}, to: {$gte: 90000}},  // from---a=======b---to
                  //                  {from: { $gte: 70001}, to: {$lte: 190000}}, // a---from=====to---b
                  {from: { $gte: 70001, $lte: 85000}, to: {$gte: 85000}}, // from---a=======to~~~b
                  //                  {from: { $lte: 80000}, to: {$gte: 80000, $lte: 100000}}, // a~~~from=======b---to
                ]
              }
            }
          ]
        }
      }
    }
  },
  {number: 1, name: 1}
)

