module Moneypenny
  class Listener < Plugin
    @registered_listeners = []

    def self.inherited(subclass)
      @registered_listeners << subclass
    end

    def self.all
      @registered_listeners
    end
  end
end
