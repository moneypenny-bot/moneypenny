require 'moneypenny/plugin'

module Moneypenny
  class Responder < Plugin
    @registered_responders = []

    def self.inherited(subclass)
      @registered_responders << subclass
    end

    def self.all
      @registered_responders
    end

  end
end
