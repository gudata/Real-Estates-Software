require 'spec_helper'
require "machinist/mongoid"

describe Sell do
  context "Вземане на картинките на Sell" do
    include AbilityHelperMethods

    before(:each) do
        @contact = Contact.make
        @user = User.make
        @sell_with_picture = make_sell(@user, @contact, :apartment)
        @sell_without_picture = make_sell(@user, @contact, :apartment)
        @picture = File.open("spec/fixtures/test1.png")
        @picture_styles = [
          :thumb,
          :small_thumb,
          :small,
          :normal
        ]
        @pictures = @sell_with_picture.pictures.build(:picture => @picture)
        @sell_with_picture.save
        @pictures_hash = @sell_with_picture.get_pictures.first
        @empty_pictures_array = @sell_without_picture.get_pictures
    end
    
    it "Когато има снимки трябва да ги взимаме във формат Hash(:style => {:url => String, :style => Symbol})" do      
      @picture_styles.each do |picture_style|
        @pictures_hash[picture_style][:style].should eql(picture_style)
        @pictures_hash[picture_style][:url].should be_kind_of(String)
      end
    end

    it "Когато няма снимки очакваме празен масив" do
      @empty_pictures_array.should be_kind_of(Array)
      @empty_pictures_array.should be_empty
    end

  end
  
end

