require 'spec_helper'

describe Term do
  before(:each) do
    @term = Term.new
  end

  it "връща правилно попълнените терми" do
    @term.to = 10
    @term.filled_keys.should include :to
    @term.filled_keys.should_not include :from
    @term.from = 100
    @term.filled_keys.should include :from
    @term.filled_keys.should have(2).elements
  end
end

