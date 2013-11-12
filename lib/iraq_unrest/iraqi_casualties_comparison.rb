module IraqUnrest

  class IraqiCasualtiesComparison < DataSet

    ATTRIBUTES = [:date, :afp, :iraq_gov, :iraq_body_count]

    attr_accessor *ATTRIBUTES

    def attributes
      ATTRIBUTES.inject(ActiveSupport::HashWithIndifferentAccess.new) do |result, key|
        result[key] = read_attribute_for_validation(key)
        result
      end
    end

    def self.raw_csv
      GoogleDoc.new.spreadsheet(file_name.to_sym)
    end

    def self.parse(data)
      result = []
      parsed = data.split("\n")

      title = parsed.slice!(0).split(",").first.gsub(/\(|\(|\:|A |\s+/, "").underscore
      comments = parsed.slice!(0..4)

      if title != file_name
        raise Exception, "Could not find a valid title in data source"
      end

      parsed.each do |row|
        fields = row.split(",", -1)
        obj = new(:date => fields[0],
                  :iraq_gov  => fields[1],
                  :iraq_body_count => fields[2],
                  :afp => fields[3])

        result << obj if obj.valid?
      end

      result
    end

  end

end
