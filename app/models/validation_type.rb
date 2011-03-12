# == Schema Information
#
# Table name: validation_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class ValidationType < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  validates :name, :presence => true
  has_and_belongs_to_many :keywords

end
