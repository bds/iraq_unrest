class IraqUnrest::Config
  class << self
    attr_accessor :timeout, :doc_id, :disclaimer
  end
  def self.configure(&block)
    yield self
  end
end
