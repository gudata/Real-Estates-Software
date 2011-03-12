class FloorType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::I18n
  include Mongoid::Versioning


  field :position, :type => Integer
  field :value, :type => Integer
  localized_field :name
  field :active, :type => Boolean, :default => true
  cache
end
