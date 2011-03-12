# == Schema Information
#
# Table name: internet_comunicators
#
#  id                           :integer(4)      not null, primary key
#  value                        :string(255)
#  internet_comunicator_type_id :integer(4)
#  contact_id                   :integer(4)
#  created_at                   :datetime
#  updated_at                   :datetime
#

class InternetComunicator < ActiveRecord::Base
  belongs_to :contact
  belongs_to :internet_comunicator_type
#  default_scope :include => [:internet_comunicator_type]

#  validates_length_of :value, :within => 4..255
  validates_associated :internet_comunicator_type
  validates :internet_comunicator_type, :presence => true
  
  def validate
    errors.add(:value, :internet_comunicator_value) if self.value.blank? or self.value.strip.blank?
#    errors.add(:internet_comunicator_type_id, :internet_comunicator_type) if !self.value.blank? or self.internet_comunicator_type_id.nil?
  end

end
