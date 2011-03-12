# == Schema Information
#
# Table name: phones
#
#  id            :integer(4)      not null, primary key
#  number        :string(255)
#  number_clean  :string(255)
#  phone_type_id :integer(4)
#  contact_id    :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Phone < ActiveRecord::Base
  #  attr_accessible :number
  belongs_to :contact
  
  belongs_to :phone_type

  before_validation :clean_phone
  #TODO - да се види защо default_scope :include => :phone_type
  #дава грешка, когато се прави проверка за съществуващ контакт
  #  default_scope :include => :phone_type

  validates  :number, :phone_type_id, :presence => true

    validates_uniqueness_of :number
    validates_uniqueness_of :number_clean

  def validate
    errors.add(:number, :phone_has_no_numbers_value) if self.number.blank? or self.number !~ /\d{2,}/
#    phone = Phone.where("(number = :number OR number_clean = :number_clean) AND contact_id != :contact_id",
#      {:number => number,
#        :number_clean => number_clean,
#        :contact_id => contact_id
#      })
#    if phone.count > 0
#      errors.add(:number, :phone_exists)
#    end
  end

  private
  def clean_phone
    self.number_clean = self.number.gsub(/[^\d]/, '')
  end


end
