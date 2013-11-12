module IraqUnrest

  class IraqGovernmentCasualtyFigure < DataSet

    ATTRIBUTES = [ :date, :civilian_killed, :police_killed, :army_killed,
                   :civilian_wounded, :police_wounded, :army_wounded,
                   :insurg_killed, :insurg_arrested ]

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
      title = parsed.slice(0).split(",").first.gsub(/\(|\(|\:|\s+/, "").chop.underscore
      comments = parsed.slice!(1..4)

      if title != file_name
        raise Exception, "Could not find a valid title in data source"
      end

      parsed.each do |row|
        fields = row.split(",", -1)

        obj = new(:date => fields[0],
                  :civilian_killed => fields[1],
                  :police_killed => fields[2],
                  :army_killed => fields[3],
                  :civilian_wounded => fields[5],
                  :police_wounded => fields[6],
                  :army_wounded => fields[7],
                  :insurg_killed => fields[9],
                  :insurg_arrested => fields[10])

        result << obj if obj.valid?
      end

      result
    end

  end

end
