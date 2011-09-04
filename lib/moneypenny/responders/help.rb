require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  class Help < Responder
    def self.help
      [ 'help', 'returns a list of available commands' ]
    end

    def self.respond(message)
      if (query = message.match(/\Ahelp\z/i))
        helps = []
        Responder.subclasses.each do |responder|
          helps << responder.help rescue nil
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
