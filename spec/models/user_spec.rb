# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  login                :string(255)     not null
#  email                :string(255)     not null
#  crypted_password     :string(255)     not null
#  password_salt        :string(255)     not null
#  persistence_token    :string(255)     not null
#  single_access_token  :string(255)     not null
#  perishable_token     :string(255)     not null
#  login_count          :integer(4)      default(0), not null
#  failed_login_count   :integer(4)      default(0), not null
#  last_request_at      :datetime
#  current_login_at     :datetime
#  last_login_at        :datetime
#  current_login_ip     :string(255)
#  last_login_ip        :string(255)
#  active               :boolean(1)      default(TRUE), not null
#  signature            :text
#  chat                 :text
#  webpage              :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  second_name          :string(255)
#  assistant            :boolean(1)
#  company_webpage      :string(255)
#  phone                :string(255)
#  mobile               :string(255)
#  birth                :datetime
#  locale               :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  role_id              :integer(4)
#  parent_id            :integer(4)
#  lft                  :integer(4)
#  rgt                  :integer(4)
#  real_name            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer(4)
#  office_id            :integer(4)
#  team_id              :integer(4)
#

require 'spec_helper'

describe User do
  include AbilityHelperMethods
  before(:each) do
    @team = make_team :rocket
  end

  it "връща себе си + родителя ако е асистент" do
    user_team_manager = @team[:user_team_manager][:user]
    user_team_manager_assistent = @team[:user_team_manager_assistent][:user]

    user_team_manager_assistent.self_and_sub_user_ids.should be_include(user_team_manager.id)
    user_team_manager_assistent.self_and_sub_user_ids.should be_include(user_team_manager_assistent.id)
  end

  it "трябва да изтрива контакта ако няма повече сосбтвеници за този потребител" do
    user_team_manager = @team[:user_team_manager][:user]
    user_team_manager_assistent = @team[:user_team_manager_assistent][:user]

    contact = Contact.make(:person_first_name => "name")
    contact.phones << Phone.new(
      :number => "112233", :phone_type => PhoneType.first
    )
    contact.save
    
    user_team_manager.contacts << contact
    user_team_manager_assistent.contacts << contact

    contact.should have(2).users

    user_team_manager.remove_contact contact

    contact.should have(1).users
    user_team_manager_assistent.remove_contact contact
    
    Contact.all(:conditions => {:id => contact.id}).should be_empty
  end

end
