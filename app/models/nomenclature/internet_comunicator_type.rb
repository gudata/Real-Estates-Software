# == Schema Information
#
# Table name: internet_comunicator_types
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  is_email   :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class InternetComunicatorType < ActiveRecord::Base
  translates :name
  has_one :internet_comunicator

  def validate
    if is_email
      found = InternetComunicatorType.find(:first, :conditions => {
          :is_email => true,
        })

      if found and found.id != id
        errors.add(:is_email, "Има вече тип имейл")
      end
    end

  end

  default_scope :include => :translations
end


