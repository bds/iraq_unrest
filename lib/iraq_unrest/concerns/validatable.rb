module IraqUnrest

  module Validatable
    def read_attribute_for_validation(key)
      send(key)
    end

    def valid?
      return false if self.date.nil?
      return false unless self.date.length == 8
      return false unless Date.strptime(self.date, "%b-%Y").past?
      return false if self.date == Date.current.strftime("%b-%Y")
      true
    end

  end

end
