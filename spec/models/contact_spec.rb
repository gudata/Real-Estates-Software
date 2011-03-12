# == Schema Information
#
# Table name: contacts
#
#  id                   :integer(4)      not null, primary key
#  is_company           :boolean(1)
#  added_by             :integer(4)
#  address_id           :integer(4)
#  nationality_id       :integer(4)
#  important            :boolean(1)
#  web                  :string(255)
#  person_first_name    :string(255)
#  person_last_name     :string(255)
#  person_middle_name   :string(255)
#  person_employment    :string(255)
#  person_position      :string(255)
#  company_name         :string(255)
#  company_branch       :string(255)
#  bank_account         :string(255)
#  iban                 :string(255)
#  mol_first_name       :string(255)
#  mol_last_name        :string(255)
#  mol_phone            :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  projects_count       :integer(4)      default(0)
#  sells_count          :integer(4)      default(0)
#  key                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Contact do

  it "При запис трябва да оставя само числата в телефона" do
    phone_type = PhoneType.create(:name => 'aaa')
    
    phone = Phone.new(:number => "asdf3234s5daf", :contact => Contact.create, :phone_type => phone_type)
    phone.save
    phone.number_clean.should eql("32345")

    contact = Contact.new(:person_first_name => "name")
    contact.phones << Phone.new(
      :number => "asdf3234s51daf", :phone_type => phone_type
    )
    contact.save
    contact.phones.first.number_clean.should eql("323451")
  end
  
end
