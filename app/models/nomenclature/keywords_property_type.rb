# == Schema Information
#
# Table name: keywords_property_types
#
#  id               :integer(4)      not null, primary key
#  property_type_id :integer(4)
#  keyword_id       :integer(4)
#  position         :integer(4)      default(0)
#  end_of_line      :boolean(1)
#  style            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class KeywordsPropertyType < ActiveRecord::Base
  before_create :set_position
  
  belongs_to :property_type
  belongs_to :keyword

  default_scope :order => "position ASC"
  INCREMENT = 20

  private
  def set_position
    if self.position.blank? || self.position == 0
      max_value = KeywordsPropertyType.maximum(:position,
        :conditions => {
          :property_type_id => self.property_type_id
        }
      ) || 0
      self.position = max_value + INCREMENT
    end
  end

end
