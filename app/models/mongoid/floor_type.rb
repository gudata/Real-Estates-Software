class FloorType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::I18n
  include Mongoid::Versioning
  include Mongoid::ActiverecordPatch

  before_validation :fix_id_types


  field :position, :type => Integer
  field :value, :type => Integer
  localized_field :name
  field :active, :type => Boolean, :default => true
  cache
end
