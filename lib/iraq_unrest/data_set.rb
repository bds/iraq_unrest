module IraqUnrest

  class DataSet
    include Validatable
    include Serializable

    def initialize(attributes={})
      self.attributes=attributes
    end

    def attributes=(attrs)
      attrs.each_pair do |k, v|
        send("#{k}=", v)
      end
    end

    class << self
      def to_csv
        DataSetFormatter.render(:csv, :object => self)
      end

      def to_html
        DataSetFormatter.render(:html, :object => self)
      end

      def to_csv!
        DataSetFormatter.render_file("#{file_name}.csv", :object => self)
      end

      def to_html!
        DataSetFormatter.render_file("#{file_name}.html", :object => self)
      end
      alias_method :visualize!, :to_html!

      def file_name
        name.demodulize.underscore
      end
    end

  end
end
