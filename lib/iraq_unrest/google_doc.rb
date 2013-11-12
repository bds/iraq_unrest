module IraqUnrest

  class GoogleDoc

    SPREADSHEETS = {:iraq_government_casualty_figure => 4,
                    :iraqi_casualties_comparison => 9}

    def spreadsheet(name)
      raise ArgumentError, "Invalid spreadsheet name" unless SPREADSHEETS.include?(name)

      begin
        uri = URI.parse("https://docs.google.com/spreadsheet/pub?hl=en_US&key=%s&hl=en_US&gid=%s&output=csv" %
                        [IraqUnrest::Config.doc_id, SPREADSHEETS[name]])

        curl = ::Curl::Easy.perform(uri.to_s) do |c|
            c.timeout = IraqUnrest::Config.timeout
        end
      rescue Curl::Err::TimeoutError => e
        raise $!, "Could not connect to Google Docs in a timely manner #{$!}", $!.backtrace
      end

      if curl.response_code != 200
        raise Exception, "Did not receive a successfull response from Google Docs"
      end

      curl.body_str
    end

  end

end
