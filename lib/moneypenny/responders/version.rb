module Moneypenny
  class Version < Responder
    def self.help
      [ 'version', 'returns the current version of Moneypenny' ]
    end

    def self.respond(message)
      if (query = message.match(/\Aversion\z/i))
        url = "https://github.com/moneypenny-bot/moneypenny/tree/#{VERSION}"
        "Current Moneypenny version: #{VERSION} (#{url})"
      else
        false
      end
    end
  end
end
