require 'test_helper'

module IraqUnrest

  describe IraqGovernmentCasualtyFigure do

    before { VCR.insert_cassette 'iraq_government_casualty_figure', :re_record_interval => 86400 }
    after  { VCR.eject_cassette }

    describe "an instance" do

      before { @object = IraqiCasualtiesComparison.new(:date => "Sep-2013") }

      describe "when asked as_json" do
        it "must be a Hash" do
          @object.as_json.must_be_instance_of Hash
        end
      end

      describe "when asked to_json" do
        it "must be a String" do
          @object.to_json.must_be_instance_of String
        end
      end

    end

    describe "the data set" do

      it "must return 88 when asked for the number of Iraqi Civilians Killed in Feb-2013" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Feb-2013" }.civilian_killed.must_equal "88"
      end

      it "must return 58 when asked for the number of Iraqi Police Killed in Dec-2008" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Dec-2008" }.police_killed.must_equal "58"
      end

      it "must return 25 when asked for the number of Iraqi Army Killed in Nov-2006" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Nov-2006" }.army_killed.must_equal "25"
      end

      it "must return 1745 when asked for the number of Iraqi Civilian Wounded in Apr-2008" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Apr-2008" }.civilian_wounded.must_equal "1745"
      end

      it "must return when asked for the number of Iraqi Police Wounded in Oct-2006" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Oct-2006" }.police_wounded.must_equal "184"
      end

      it "must return 89 when asked for the number of Iraqi Army Wounded in Juy-2013" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Jul-2013" }.army_wounded.must_equal "89"
      end

      it "must return 54 when asked for the number of Insurgents Killed in Jan-2010" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Jan-2010" }.insurg_killed.must_equal "54"
      end

      it "must return 949 when asked for the number of Insurgents Arrested in Jun-2008" do
        IraqGovernmentCasualtyFigure.all.find {|item| item.date == "Jun-2008" }.insurg_arrested.must_equal "949"
      end

    end

    describe "class methods" do

      describe "when asked for a raw csv" do
        it "must return a String" do
          IraqGovernmentCasualtyFigure.raw_csv.must_be_kind_of String
        end
      end

      describe "when asked for a CSV" do

        before { @csv = IraqGovernmentCasualtyFigure.to_csv }

        it "must return a CSV String" do
          @csv.must_be_kind_of String
        end

        describe "Parsring the String into a CSV object" do

          before do
            @csv_object = CSV.parse(@csv, :headers => true,
                                    :header_converters => :symbol)
          end

          it "must have the correct headers" do
            @csv_object.headers.must_equal IraqGovernmentCasualtyFigure::ATTRIBUTES
          end

          it "must have a dates in the format of mmm-YYYY in the first colum" do
            @csv_object.values_at(:date).flatten.map {|date| Date::strptime(date,"%b-%Y") }
          end

          it "must have at least 90 rows" do
            @csv_object.size.must_be :>=, 90
          end

        end

      end

      describe "when asked to generate a CSV" do

        before { @file = IraqGovernmentCasualtyFigure.to_csv! }

        it "must return a File object" do
          @file.must_be_kind_of File
        end

        it "must create a file" do
          @file.path.must_equal IraqGovernmentCasualtyFigure.file_name + ".csv"
          (File.exists? @file.path).must_equal true
        end

        describe "CSV file" do

          before do
            @csv = CSV.table(@file.path, :skip_lines => /#/)
          end

          it "must have the correct headers" do
            @csv.headers.must_equal IraqGovernmentCasualtyFigure::ATTRIBUTES
          end

          it "wont be empty" do
            @csv.empty?.must_equal false
          end

        end

      end

      describe "when asked as_json#to_json" do

        before do
          @json = IraqUnrest::IraqGovernmentCasualtyFigure.as_json.to_json
        end

        it "must return a JSON string of all objects" do
          @json.wont_be_nil
          @json.must_be_kind_of String
          @parsed = JSON.parse(@json)
          @parsed.must_be_kind_of Array
          @parsed.first.empty?.must_equal false
        end

      end

      describe "when asked as_json" do

        before do
          @json = IraqUnrest::IraqGovernmentCasualtyFigure.as_json
        end

        it "must return an Array" do
          @json.wont_be_nil
          @json.must_be_kind_of Array
          @generated = JSON.generate(@json)
          @generated.must_be_kind_of String
        end

      end

      describe "when asked to generate a rickshaw data structure" do
        before do
          @data = IraqGovernmentCasualtyFigure.as_rickshaw
          @attr = [:civilian_killed, :police_killed, :army_killed, :civilian_wounded, :police_wounded, :army_wounded, :insurg_killed, :insurg_arrested]
        end

        it "must have all keys except a date" do
          @data.keys.must_equal @attr
        end

        it "must contain formatted array of hashes for each attribute" do
          @attr.each do |attr|
            @data[attr].each do |data_point|
              data_point.keys.must_equal [:x, :y]
              Date.strptime(data_point[:x].to_s, "%s").must_be_instance_of Date
            end
          end
        end

      end

      describe "when asked for HTML" do

        before do
          @html = IraqGovernmentCasualtyFigure.to_html
        end

        it "must return a String" do
          @html.must_be_kind_of String
        end

      end

      describe "when asked to generate HTML" do

        before { @file = IraqGovernmentCasualtyFigure.to_html! }

        it "must return a File object" do
          @file.must_be_kind_of File
        end

        it "must create a file" do
          @file.path.must_equal IraqGovernmentCasualtyFigure.file_name + ".html"
          (File.exists? @file.path).must_equal true
        end

      end

      describe "when asked to visualize all records" do

        before { @file = IraqGovernmentCasualtyFigure.visualize! }

        it "must return a File object" do
          @file.must_be_kind_of File
        end

        it "must create a file" do
          @file.path.must_equal IraqGovernmentCasualtyFigure.file_name + ".html"
          (File.exists? @file.path).must_equal true
        end

      end

      describe "when asked for all records" do
        it "must return a collection of IraqGovernmentCasualtyFigure objects" do
          data = IraqGovernmentCasualtyFigure.all
          data.must_be_kind_of Enumerable
          data.size.must_be :>, 90
          data.first.must_be_kind_of IraqGovernmentCasualtyFigure
        end
      end

      describe "when asked for a file name" do
        it "must respond with a properly formatted file name" do
          IraqGovernmentCasualtyFigure.file_name.must_equal 'iraq_government_casualty_figure'
        end
      end

      describe "when asked to parse raw data" do
        it "must raise an Exception if it cannot find a title" do
          err = proc {IraqGovernmentCasualtyFigure.parse("Foo,Bar,Baz,\n")}.must_raise Exception
          err.message.must_match /^Could not find a valid title in data source$/
        end
      end

    end

  end
end
