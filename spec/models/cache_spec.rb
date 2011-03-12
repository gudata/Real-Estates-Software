require 'spec_helper'
#require "machinist/mongoid"

describe Cache do
  before(:each) do
    FenceType.make
    FenceType.make
    @cache = Cache.new
  end

  it "Взимане на ключ за кеш" do
    @cache.get_key(FenceType.new).should eql "FenceType"
    @cache.get_key(FenceType).should eql "FenceType"
    @cache.get_key("FenceType").should eql "FenceType"
  end

  it "Намира ключ в кеша по обект " do
    record = FenceType.new
    @cache.key?(record).should be_true
  end

  it "Намира колекция в кеша по ключ" do
    record = FenceType.new
    @cache[record].should be_kind_of Array
    @cache[FenceType].should be_kind_of Array
    @cache["FenceType"].should be_kind_of Array

#    @cache[record].first.should be_kind_of FenceType
    @cache[record].first.should be_kind_of OpenStruct

    @cache[record].should have(2).items

    class SomeBing
    end
    lambda { @cache[SomeBing.new] }.should raise_exception
    lambda { @cache["SomeBing"] }.should raise_exception
    lambda { @cache[SomeBing] }.should raise_exception
  end

  it "Тестване на observer-а дали осъвременява кеша за модела на оградите" do
    $cache[FenceType].should_not have(1).items
    $cache[FenceType].should have(2).items
    record = FenceType.create :name => 'somename'
    $cache[FenceType].should have(3).items
    $cache[FenceType].select {|f| f.name == 'somename'}.should_not be_empty

    record.name = 'othername'
    record.save
    $cache[FenceType].select {|f| f.name == 'othername'}.should_not be_empty
    
    record.destroy
    $cache[FenceType].should have(2).items
  end
  
#  it "Преинициализацията на кеша" do
#  end
#  it "Осъвременяване на единичен запис" do
#  end
end