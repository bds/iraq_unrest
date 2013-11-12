module IraqUnrest

  class DataSet

    def initialize(attributes={})
      self.attributes=attributes
    end

    def attributes=(attrs)
      attrs.each_pair do |k, v|
        send("#{k}=", v)
      end
    end

    class << self

      def parse
      end

      def all
        parse(self.raw_csv)
      end

      def raw_csv
        doc = IraqUnrest::GoogleDoc.new.spreadsheet(self.file_name.to_sym)
      end

      def file_name
        self.name.split("::").last.underscore
      end

      # Need to make this clear that this is picking up the
      # result of ActiveModelSerializer
      def to_json
        ActiveModel::ArraySerializer.new(self.all).to_json
      end

      def as_json
        ActiveModel::ArraySerializer.new(self.all).as_json
      end

      # FIXME - we could probably remove a layer of abstraction here
      def to_rickshaw
        IraqUnrest::Serializers.as_rickshaw(self.all)
      end

      def to_csv
        IraqUnrest::Serializers.as_csv(self.all)
      end

      def to_html
        IraqUnrest::Serializers.as_html(self.all)
      end

      def generate_csv!
        file = File.new(self.file_name + ".csv", "w")
        file.puts IraqUnrest::Config.disclaimer
        csv_data = self.to_csv.to_s.split("\n")
        csv_data.each { |row| file.puts row }

        file.close
        file
      end

      def generate_html!
        file = File.new(self.file_name + ".html", "w")
        file.puts self.to_html
        file.close
        file
      end

    end
  end
end
