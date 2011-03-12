# Patch the ActionController::RecordIdentifier.dom_id to work with hash

class Hash
#  include ActiveModel::Naming
  extend ActiveModel::Naming

  def to_key
    [self.object_id.abs]
  end

  def name
    self.name
  end

  def self.name
    "Hash"
  end

end