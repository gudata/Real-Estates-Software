require 'spec_helper'
#require "machinist/mongoid"

describe SearchCriteria do
  context "Criteria English" do
    it "should be correct pluralize" do
      "SearchCriteria".pluralize.should eql("SearchCriterias")
      "Criteria".pluralize.should eql("Criterias")

      "SearchCriterias".singularize.should eql("SearchCriteria")
      "Criterias".singularize.should eql("Criteria")
    end
  end
  context "Работа с термини" do

    before(:each) do
      @search_criteria = SearchCriteria.new

      @apartment = PropertyType.make(:apartment)
      @office = PropertyType.make(:office)

      terms = (1..10).collect {|i| generate_term(i)}

      @search_criteria.property_type_id = @apartment.id
      @search_criteria.terms = terms
    end

    def generate_term i
      Term.new(
        :tag => "tag#{i}",
        :keyword_id => "#{i}",
        :name => "name#{i}",
        :value => i,
        :from => i,
        :to => i,
        :position => "1"
      )
    end

    it "Взимане на терма по име на таг" do
      new_terms = [
        generate_term(1), generate_term(1000)
      ]

      @search_criteria.terms_from_terms(new_terms)
      @search_criteria.term('tag1').tag.should eql 'tag1'
      @search_criteria.term('tag1000').tag.should eql 'tag1000'
    end

    it "Присвояване на терми при използване на стари терми" do
      # one old term
      # add new term
      new_terms = [
        generate_term(1), generate_term(1000)
      ]

      @search_criteria.terms_from_terms(new_terms)
      @search_criteria.terms.first.tag.should eql 'tag1'
      @search_criteria.terms.first.keyword_id.should eql new_terms.first.keyword_id

      @search_criteria.terms.last.tag.should eql "tag1000"
      @search_criteria.terms.last.keyword_id.should_not eql new_terms.last.keyword_id

      @search_criteria.should have(2).terms
    end

    def generate_keyword(i, property_type)
      k = Keyword.create(
        :tag => "tag#{i}",
        :name => "name#{i}",
        :patern => ".",
        :as => "String"
      )
      k.property_types << property_type
      k
    end

    it "Присвояване на терми при използване на (винаги нови) ключови думи" do
      # add one old keyword and one new keyword
      new_keywords = [
        generate_keyword(1, @apartment),
        generate_keyword(1000, @apartment),
      ]

      old_term = @search_criteria.terms.first

      @search_criteria.terms_from_keywords(new_keywords, @apartment.id)

      @search_criteria.terms.first.tag.should eql 'tag1'
      @search_criteria.terms.first.value.should eql 1
      @search_criteria.terms.first.value.should be_kind_of Fixnum
      @search_criteria.terms.first.keyword_id.should eql old_term.keyword_id
      @search_criteria.terms.first.position.should eql new_keywords.first.position(@apartment.id)

      @search_criteria.terms.last.tag.should eql "tag1000"
      @search_criteria.terms.last.value.should eql nil
      @search_criteria.terms.last.keyword_id.should eql new_keywords.last.id
      @search_criteria.terms.last.position.should eql new_keywords.last.position(@apartment.id)

      @search_criteria.should have(2).terms
    end

    it "Присвояване на терми на критерия, която няма терми" do
      # add one old keyword and one new keyword
      new_keywords = [
        generate_keyword(1, @apartment),
        generate_keyword(1000, @apartment),
      ]

      @search_criteria.terms.clear

      @search_criteria.terms_from_keywords(new_keywords, @apartment.id)

      @search_criteria.terms.first.tag.should eql 'tag1'
      @search_criteria.terms.first.value.should eql nil
      @search_criteria.terms.first.keyword_id.should eql @search_criteria.terms.first.keyword_id
      @search_criteria.terms.first.position.should eql new_keywords.first.position(@apartment.id)

      @search_criteria.terms.last.tag.should eql "tag1000"
      @search_criteria.terms.last.value.should eql nil
      @search_criteria.terms.last.keyword_id.should eql new_keywords.last.id
      @search_criteria.terms.last.position.should eql new_keywords.last.position(@apartment.id)

      @search_criteria.should have(2).terms
    end
  end

end