module IraqUnrest

  module Serializers

    # Gives to_json and as_json
    # Used by both members and collections
    class IraqiCasualtiesComparisonSerializer < ::ActiveModel::Serializer
      attributes :date, :afp, :iraq_gov, :iraq_body_count

      self.root = false

      def date
        Date.strptime(object.date, "%b-%Y").end_of_month.to_time.to_i
      end
    end

    class IraqGovernmentCasualtyFigureSerializer < ::ActiveModel::Serializer
      attributes :date, :civilian_killed, :police_killed, :army_killed,
                 :civilian_wounded, :police_wounded, :army_wounded,
                 :insurg_killed, :insurg_arrested

      self.root = false

      def date
        Date.strptime(object.date, "%b-%Y").end_of_month.to_time.to_i
      end
    end

    def self.as_rickshaw(data)
      result = {}
      attrs = data.first.attributes.except(:date).symbolize_keys.keys

      data.each do |row|
        attrs.each do |attr|
          result[attr] ||= []
          result[attr] << { :x => Date.strptime(row.date, "%b-%Y").end_of_month.to_time.to_i,
                            :y => row.send(attr).to_i ||= 0 }
        end
      end

      result.each {|k,v| result[k].sort_by! { |hsh| hsh[:x]} }
      result
    end

  end
end
