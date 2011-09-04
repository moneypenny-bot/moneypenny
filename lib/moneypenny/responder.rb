module Moneypenny
  class Responder
    @registered_responders = []

    def self.inherited(subclass)
      @registered_responders << subclass
    end

    def self.all
      @registered_responders
    end
    
    def self.subclasses
        classes = []
        ObjectSpace.each_object do |klass|
          next unless Module === klass
          classes << klass if self > klass
        end
        classes
      end
  end
end
