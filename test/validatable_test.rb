require 'test_helper'

module IraqUnrest

  class DummyClass < IraqUnrest::DataSet; attr_accessor :date end

  describe Validatable do

    before { @object = DummyClass.new(:date => "Sep-2013") }

    it "wont recognize this month as valid" do
      @object.date = Date.current.strftime("%b-%Y")
      @object.wont_be(:valid?)
    end

    it "wont recognize next month as valid" do
      next_month = Date.current.next_month.strftime("%b-%Y")
      @object.date = next_month
      @object.wont_be(:valid?)
    end

    it "must recognize Sep-2013 as a valid date" do
      @object.date = "Sep-2013"
      @object.must_be(:valid?)
    end

    it "wont recognize 01/01/1970 as a valid date" do
      @object.date = "01/01/1970"
      @object.wont_be(:valid?)
    end

  end

end
