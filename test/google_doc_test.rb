require 'test_helper'

module IraqUnrest

  describe GoogleDoc do

    before do
      VCR.insert_cassette 'iraq_government_casualty_figure', :re_record_interval => 86400
      @doc = GoogleDoc.new
    end

    after { VCR.eject_cassette }

    describe "when asked for a spreadsheet by name" do

      it "must return a String object" do
        spreadsheet =  @doc.spreadsheet(:iraq_government_casualty_figure)
        spreadsheet.must_be_kind_of String
      end

      it "must return an ArgumentError when the name is invalid" do
        proc {@doc.spreadsheet(:foobaz)}.must_raise ArgumentError
      end

    end

    describe "when there are network problems" do

      before do
        WebMock.disable_net_connect!
        @doc = GoogleDoc.new
      end
      after  { WebMock.allow_net_connect! }

      it "must raise a TimeoutError with a custom message for long requests" do
        stub_request(:get,
                     "https://docs.google.com/spreadsheet/pub?gid=4&hl=en_US&key=0Aia6y6NymliRdEZESktBSWVqNWM1dkZOSGNIVmtFZEE&output=csv").
                     to_timeout
        err = proc {@doc.spreadsheet(:iraq_government_casualty_figure)}.must_raise Curl::Err::TimeoutError
        err.message.must_match /^Could not connect to Google Docs in a timely manner Curl::Err::TimeoutError$/
      end

      it "must raise an Exception with a custom message when the response code when not 200" do
        stub_request(:get,
                     "https://docs.google.com/spreadsheet/pub?gid=4&hl=en_US&key=0Aia6y6NymliRdEZESktBSWVqNWM1dkZOSGNIVmtFZEE&output=csv").
                      to_return(:status => 500, :body => "", :headers => {})

        err = proc {@doc.spreadsheet(:iraq_government_casualty_figure)}.must_raise Exception
        err.message.must_match /^Did not receive a successfull response from Google Docs$/
      end

    end

  end

end
