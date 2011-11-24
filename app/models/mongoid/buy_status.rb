class BuyStatus
  include Mongoid::Document
  include Mongoid::Timestamps
  #  include MongoTranslation
  include Mongoid::I18n
  include Mongoid::Versioning
  include Mongoid::ActiverecordPatch

  before_validation :fix_id_types

  #  belongs_to :buy, :inverse_of => :terms
  #  
  # towa ne triabwa da e tuka!!!
  field :hide_on_this_buy_status, :type => Boolean, :default => false
#  field :client_visible, :type => Boolean, :default => false
  field :position, :type => Integer
  localized_field :name
  cache
  #  translates :name
end
