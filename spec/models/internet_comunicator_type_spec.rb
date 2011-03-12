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

require 'spec_helper'

describe InternetComunicatorType do

  it "имаме само един такъв тип" do
    InternetComunicatorType.create!(:is_email => true)
    lambda {
      InternetComunicatorType.create!(:is_email => true)
      InternetComunicatorType.create!(:is_email => true)
    }.should raise_error
    InternetComunicatorType.create(:is_email => false).should be_valid
    InternetComunicatorType.create(:is_email => false).should be_valid
  end
end

