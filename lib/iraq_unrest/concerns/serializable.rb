module IraqUnrest

  module Serializable
    extend ActiveSupport::Concern

    delegate :to_json, :as_json, :to => :serialize

    def read_attribute_for_serialization(key)
      send(key)
    end

    def active_model_serializer
      "IraqUnrest::Serializers::#{self.class.file_name.camelcase}Serializer".constantize
    end

    def serialize(serializer=active_model_serializer)
      serializer.new(self)
    end

    module ClassMethods

      def all
        @all ||= parse(raw_csv)
      end

      def as_json
        ActiveModel::ArraySerializer.new(all).as_json
      end

      def as_rickshaw
        Serializers.as_rickshaw(all)
      end

    end

  end
end
