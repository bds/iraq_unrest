module IraqUnrest

  # Code from https://github.com/sandal/fatty
  class Format
    attr_accessor :params

    # FIXME: Need to understand where the methods to be
    #        implemented are declared
    def validate
    end
  end

  class Formatter

    class << self

      def formats
        @formats ||= {}
      end

      def required_params(*args)
        @required_params = args
      end

      def format(name, options={}, &block)
        formats[name] = Class.new(IraqUnrest::Format, &block)
      end

      def validate(format, params={})
        check_required_params(params)
      end

     # puts ListFormatter.render(:csv, :data => data)
     def render(format, params={})
        validate(format, params)

        # Each format object implements all the required steps
        # so they they can be used interchangeably
        format_obj = formats[format].new

        # Customize
        format_obj.params = params
        format_obj.validate
        format_obj.render
      end

      def render_file(file, params={})
        format = File.extname(file).delete(".").to_sym

        File.open(file, "w") do |f|
          f << render(format, params)
        end
      end

      private

      def check_required_params(params)
        unless (@required_params || []).all? { |k| params.key?(k) }
          raise Exception, "One or more required params is missing"
        end
      end

    end
  end

  class DataSetFormatter < Formatter

    required_params :object

    format :csv do

      def render
        tpl = <<-EOS
          # header
          csv << self::ATTRIBUTES

          # data rows
          self.all.each do |row|
            csv << row.attributes.values
          end
        EOS
        template = Tilt::CSVTemplate.new { tpl }
        template.render(params[:object])
      end
    end

    format :html do

      def render
        object = params[:object]
        erb_dir = File.dirname(__FILE__) + "/erb"

        template = Tilt.new(erb_dir + "/" + object.file_name + ".html.erb")
        header   = Tilt.new(erb_dir + '/header.html.erb')
        template.render(self, :header => header.render,
                              :data   => object.as_rickshaw)
      end

    end

  end

end
