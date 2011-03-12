# == Schema Information
#
# Table name: standart_choices
#
#  id         :integer(4)      not null, primary key
#  position   :integer(4)
#  active     :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

# This class provides Yes/No/Unknown options for the terms
class StandartChoice < ActiveRecord::Base
  translates :name
end
