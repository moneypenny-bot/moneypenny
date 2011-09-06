module Moneypenny
  module Plugins
    module Responders
      class Version < Responder
        def help
          [ 'version', 'returns the current version of Moneypenny' ]
        end
    
        def respond(message)
          if (query = message.match(/\Aversion\z/i))
            url = "https://github.com/moneypenny-bot/moneypenny/tree/#{VERSION}"
            "Current Moneypenny version: #{VERSION} (#{url})"
          else
            false
          end
        end
      end
    end
  end
end
    