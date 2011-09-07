module Moneypenny
  class Plugin
    include HasConfig

    attr_reader :moneypenny

    def initialize(moneypenny)
      @moneypenny = moneypenny
    end
  end
end
