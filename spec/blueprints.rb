require 'machinist/active_record'
require 'machinist/mongoid'

require 'sham'
require 'faker'
require 'md5'


module Machinist
  class Lathe
    def assign_attribute(key, value)
      if @object.kind_of? ActiveRecord::Base
        assign_attribute_active_record(key, value)
      elsif @object.class.include? Mongoid::Document
        assign_attribute_mongoid(key, value)
      elsif @object.class.include? MongoMapper::Document or @object.class.include? MongoMapper::EmbeddedDocument
        assign_attribute_mongo_mapper(key, value)
      else
        raise Exception("Unknown mapper")
      end
    end

    # mongoid
    def assign_attribute_mongoid(key, value)
      assigned_attributes[key.to_sym] = value
      @object.process(key => value)
    end

    # mongo_mapper
    def assign_attribute_mongo_mapper(key, value)
      assigned_attributes[key.to_sym] = value
      if @object.respond_to? "#{key}="
        @object.send("#{key}=", value)
      else
        @object[key] = value
      end
    end

    def assign_attribute_active_record(key, value)
      assigned_attributes[key.to_sym] = value
      @object.send("#{key}=", value)
    end
    
  end
end



# http://faker.rubyforge.org/rdoc/
Sham.define do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  login { Faker::Name.name }
  first_name { Faker::Name.first_name }
  second_name { Faker::Name.last_name }
  last_name { Faker::Name.last_name }
  mobile {Faker::PhoneNumber.phone_number}
  phone {Faker::PhoneNumber.phone_number}
  phone_type(:unique => false) {["Служебен", "Факс", "Личен","Домашен", "Мобилен", "Стационарен"]}
  team_name(:unique => false) {["Отбор черешка", "Отбор ябълка", "Отбор маргаритка"].rand}
  
  title { Faker::Lorem.sentence }
  paragraph { Faker::Lorem.paragraph }
  paragraphs { Faker::Lorem.paragraphs }
  password {(1..10).map { ('a'..'z').to_a.rand }.join}
  word { Faker::Lorem.words(1)}
  assistant { [true, false].rand }

  password_salt { Authlogic::Random.hex_token }
  crypted_password { Authlogic::CryptoProviders::Sha512.encrypt(password + password_salt) }
  persistence_token(:unique => true) { Authlogic::Random.hex_token }
  single_access_token(:unique => true) { Authlogic::Random.friendly_token }
  perishable_token { Authlogic::Random.friendly_token }
  active { true }

  country {Faker::Address.uk_country}
  district {Faker::Address.us_state}
  municipality {Faker::Address.city}
  city {Faker::Address.city()}
  street {Faker::Address.street_name}
  number {[1...100].rand}
  offer_number {rand(9999999999)}
  status(:unique => false) {["Регистриран", "Огледан", "Отказан", "Сделка"]}

  sell_type(:unique => false) {[{:name => "Продава", :category => 2, :tag => "sellers"},{:name => "Отдава", :category => 2, :tag => "renters"}].rand}
  buy_type(:unique => false) {[{:name => "Купува", :category => 1, :tag => "buyers"},{:name => "Наема", :category => 1, :tag => "letters"}].rand}
  property_category_location(:unique => false){["на море", "на планина"].rand}
  property_type(:unique => false) {["Апартамент","Офис","Къща"].rand}
  source(:unique => false) {["печат","интернет"].rand}
  furnish(:unique => false) {["Обзавден","Необзаведен","Полуобзаведен"].rand}
  key {MD5.md5(rand(99131551412).to_s).to_s}

  #проект
  project_stage(:unique => false){["Акт-15", "Акт-16", "Незавършен"].rand}

end

Team.blueprint do
  name {Sham.team_name}
end

Team.blueprint(:team_name) do
  name {team_name.to_s}
end

Role.blueprint() do
  name {"Imposiblle role"}
  ident{-1}
  parent_id{nil}
end

Role.blueprint(:manager) do
  name {"Мениджър"}
  ident{0}
  parent{nil}
end

Role.blueprint(:team_manager) do
  name {"Мениджър екип"}
  ident {1}
  parent {Role.make(:manager)}
end

Role.blueprint(:consultant) do
  name {"Консултант"}
  ident {2}
  parent {Role.make(:team_manager)}
end

Role.blueprint(:partner) do
  name {"Партньор"}
  ident {3}
  parent {Role.make(:manager)}
end

Role.blueprint(:guest) do
  name {"Гост"}
  ident {4}
  parent {Role.make(:manager)}
end

Office.blueprint do
  name {"Лозенец офис"}
end

User.blueprint do
  first_name
  second_name
  last_name
  mobile {Sham.phone}
  phone {Sham.phone}
  email { Sham.email}
  login { Sham.login}
  role {Role.make(:consultant)}
  assistant {false}
  team {Team.make}
  parent {nil}
  office {Office.make}
  password {"1122"}
  password_confirmation {"1122"}
  crypted_password
  password_salt
  persistence_token
  single_access_token
  perishable_token
  login_count {0}
  failed_login_count {0}
end

Status.blueprint do
  name {Sham.status}
end

Source.blueprint do
  name {Sham.source}
end

Furnish.blueprint do
  name {Sham.furnish}
end

FenceType.blueprint do
  active {true}
  name {Sham.name}
end

Team.blueprint do
  name {Sham.title}
end

Team.blueprint(:team_name) do
  name {:team_name.to_s}
end

PhoneType.blueprint do
  name {Sham.phone_type}
end

Phone.blueprint do
  number {Sham.phone}
  phone_type {PhoneType.make}
end

Country.blueprint do
  name {Faker::Address.uk_country}
end

District.blueprint do
  name {Faker::Address.us_state}
  country {Country.make}
end

Municipality.blueprint do
  name {Faker::Address.city}
  district {District.make}
end

City.blueprint do
  name {Faker::Address.city}
  municipality {Municipality.make}
end


Address.blueprint do
  country {Country.make}
  district {District.make}
  municipality {Municipality.make}
end

PropertyCategoryLocation.blueprint do
  name {Sham.property_category_location}
end

ProjectStage.blueprint do
  name {Sham.project_stage}
end

PropertyType.blueprint do
  name {Sham.property_type}
end

PropertyType.blueprint(:apartment) do
  name {"Апартамент"}
end

PropertyType.blueprint(:office) do
  name {"Офис"}
end
PropertyType.blueprint(:house) do
  name {"Къща"}
end

Keyword.blueprint do
  name {"Цена"}
  tag {"price"}
  patern {"Integer"}
  as {"string"}
  kind_of_search {"range"}  
end

Keyword.blueprint(:area) do
  name {"Площ"}
  tag {"area"}
  patern {"Integer"}
  as {"string"}
  kind_of_search {"range"}
end

Keyword.blueprint(:floor) do
  name {"Етаж"}
  tag {"floor"}
  patern {"Integer"}
  as {"string"}
  kind_of_search {"range"}  
end

Keyword.blueprint(:phone) do
  name {"Телефон"}
  tag {"phone"}
  patern {"Phone"}
  as {"select"}
  kind_of_search {"exact"}
end

Keyword.blueprint(:furniture) do
  name {"Обзаведен"}
  tag {"furniture"}
  patern {"Furnish"}
  as {"multiple_select"}
  kind_of_search {"multiple"}
end

Keyword.blueprint(:infrastructure) do
  name {"Инфраструктура"}
  tag {"infrastructure"}
  patern {"InfrastructureType"}
  as {"check_boxes"}
  kind_of_search {"multiple"}
end

Contact.blueprint do
  company_name {Sham.name}
  person_first_name {Sham.name}
  is_company { false }
  phones { [Phone.make]}
  address {Address.make}
  key {Sham.key}
  # todo
end

Project.blueprint do
  name {Sham.title}
  status {Status.make}
  source {Source.make}
  furnish {Furnish.make}
  user {User.make(:role => Role.make(:consultant))}
  contact {Contact.make} # _unsaved.errors.full_messages
  team {Team.make}
  finish_date {Time.now}
  contact_person {Sham.name}
  contact_person_phone {Sham.phone}
  address {Address.make}
  property_category_location {PropertyCategoryLocation.make}
  project_stage {ProjectStage.make}
end


OfferType.blueprint do
  name {Sham.sell_type[:name]}
  category {Sham.sell_type[:category]}
  tag {Sham.sell_type[:tag]}
end

Sell.blueprint do
  user {User.make(:role => Role.make(:consultant))}
  contact {Contact.make}
  address {Address.make}
  property_type {PropertyType.make}
  offer_type {OfferType.make}
  status {Status.make}
  source {Source.make}
  source_value {Sham.name}
  keywords {[Keyword.make]}  
end

Buy.blueprint do
  contact_id {Contact.make.id}
  offer_type_id {OfferType.make.id}
  created_by_user_id {User.make.id}
  user_id {User.make.id}
  source {Source.make}
  source_value {Sham.name}
  status_id {Status.make.id}
  number {Sham.offer_number}
  name {Sham.name}
  description {Sham.paragraph}
end

SearchCriteria.blueprint do
  buy {Buy.make}
  property_type_id {PropertyType.make.id}
  user_id {User.make.id}
end