require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Responders
    class Help
      def self.help
        [ 'help', 'returns a list of available commands' ]
      end

      def self.respond(message)
        if (query = message.match(/\Ahelp\z/i))
          helps = []
          Responders.constants.each do |responder|
            helps << eval("Responders::#{responder}").help rescue nil
          end
          ljust = helps.collect{|x| x[0].size }.max + 3
          helps.collect!{ |x| x[0].to_s.ljust(ljust) + x[1].to_s }
          helps.join("\n")
        else
          false
        end
      end
    end
  end
end
