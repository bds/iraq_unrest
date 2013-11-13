require 'test_helper'

module IraqUnrest

  describe IraqiCasualtiesComparison do

    before { VCR.insert_cassette 'iraqi_casualties_comparison', :re_record_interval => 86400 }
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

      it "must return 609 when asked for the number of casualties reported in Jan-2004 by the Iraq Body Count" do
        IraqiCasualtiesComparison.all.find {|item| item.date == "Jan-2004" }.iraq_body_count.must_equal "609"
      end

      it "must return 618 when asked for the number of casualties reported in Aug-2009 by the Iraq Body Count" do
        IraqiCasualtiesComparison.all.find {|item| item.date == "Aug-2009" }.iraq_body_count.must_equal "618"
      end

      it "must return 1850 when asked for the number of casualties reported in Jul-2006 by the Iraq Government" do
        IraqiCasualtiesComparison.all.find {|item| item.date == "Jul-2006" }.iraq_gov.must_equal "1850"
      end

      it "must return 205 when asked for the number of casualties reported in Apr-2013 by the Iraq Government" do
        IraqiCasualtiesComparison.all.find {|item| item.date == "Apr-2013" }.iraq_gov.must_equal "205"
      end

      it "must return 253 when asked for the number of casualties reported in Sep-2012 by the AFP" do
        IraqiCasualtiesComparison.all.find {|item| item.date == "Sep-2012" }.afp.must_equal "253"
      end

      it "must return 220 when asked for the number of casualties reported in Feb-2013 by the AFP" do
        IraqiCasualtiesComparison.all.find {|item| item.date == "Feb-2013" }.afp.must_equal "220"
      end

    end

    describe "class methods" do

      describe "when asked for a raw csv" do
        it "must return a String" do
          IraqiCasualtiesComparison.raw_csv.must_be_kind_of String
        end
      end

      describe "when asked for a CSV" do

        before { @csv = IraqiCasualtiesComparison.to_csv }

        it "must return a String" do
          @csv.must_be_kind_of String
        end

        describe "Parsring the String into a CSV object" do

          before do
            @csv_object = CSV.parse(@csv, :headers => true,
                                    :header_converters => :symbol)
          end

          it "must have the correct headers" do
            @csv_object.headers.must_equal IraqiCasualtiesComparison::ATTRIBUTES
          end

          it "must have a dates in the format of mmm-YYYY in the first colum" do
            @csv_object.values_at(:date).flatten.map {|date| Date::strptime(date,"%b-%Y") }
          end

          it "must have at least 100 rows" do
            @csv_object.size.must_be :>=, 100
          end

        end

      end

      describe "when asked to generate a CSV" do

        before { @file = IraqiCasualtiesComparison.to_csv! }

        it "must return a File object" do
          @file.must_be_kind_of File
        end

        it "must create a file" do
          @file.path.must_equal IraqiCasualtiesComparison.file_name + ".csv"
          (File.exists? @file.path).must_equal true
        end

        describe "CSV file" do

          before do
            @csv = CSV.table(@file.path)
          end

          it "must have the correct headers" do
            @csv.headers.must_equal IraqiCasualtiesComparison::ATTRIBUTES
          end

          it "wont be empty" do
            @csv.empty?.must_equal false
          end

        end

      end

      describe "when asked as_json#to_json" do

        before do
          @json = IraqUnrest::IraqiCasualtiesComparison.as_json.to_json
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
          @json = IraqUnrest::IraqiCasualtiesComparison.as_json
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
          @data = IraqiCasualtiesComparison.as_rickshaw
          @attr = [:afp, :iraq_gov, :iraq_body_count]
        end

        it "must have keys [:afp, :iraq_gov, :iraq_body_count] and not include a date" do
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
          @html = IraqiCasualtiesComparison.to_html
        end

        it "must return a String" do
          @html.must_be_kind_of String
        end

      end

      describe "when asked to generate HTML" do

        before { @file = IraqiCasualtiesComparison.to_html! }

        it "must return a File object" do
          @file.must_be_kind_of File
        end

        it "must create a file" do
          @file.path.must_equal IraqiCasualtiesComparison.file_name + ".html"
          (File.exists? @file.path).must_equal true
        end

      end

      describe "when asked to visualize all records" do

        before { @file = IraqiCasualtiesComparison.visualize! }

        it "must return a File object" do
          @file.must_be_kind_of File
        end

        it "must create a file" do
          @file.path.must_equal IraqiCasualtiesComparison.file_name + ".html"
          (File.exists? @file.path).must_equal true
        end

      end

      describe "when asked for all records" do
        it "must return a collection of IraqiCasualtiesComparison objects" do
          data = IraqiCasualtiesComparison.all
          data.must_be_kind_of Enumerable
          data.size.must_be :>, 100
          data.first.must_be_kind_of IraqiCasualtiesComparison
        end
      end

      describe "when asked for a file name" do
        it "must respond with a properly formatted file name" do
          IraqiCasualtiesComparison.file_name.must_equal 'iraqi_casualties_comparison'
        end
      end

      describe "when asked to parse raw data" do
        it "must raise an Exception if it cannot find a title" do
          err = proc {IraqiCasualtiesComparison.parse("Foo,Bar,Baz,\n")}.must_raise Exception
          err.message.must_match /^Could not find a valid title in data source$/
        end
      end

    end

  end

end
