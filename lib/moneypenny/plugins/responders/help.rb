require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Plugins
    module Responders
      class Help < Responder
        def help
          [ 'help', 'returns a list of available commands' ]
        end
    
        def respond(message)
          if (query = message.match(/\Ahelp\z/i))
            helps = []
            moneypenny.responders.each do |responder|
              helps << responder.help rescue nil
            end
            helps.sort!{ |a, b| a[0] <=> b[0] }
            ljust = helps.collect{ |x| x[0].size }.max + 3
            helps.collect!{ |x| x[0].to_s.ljust(ljust) + x[1].to_s }
            helps.join("\n")
          else
            false
          end
        end
      end
    end
  end
end
  