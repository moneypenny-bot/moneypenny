require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  class Define < Responder
    def self.help
      [ 'define space', 'returns Urban Dictionary definition for space' ]
    end
    
    def self.respond(message)
      if (query = message.match(/\Adefine\ (.+)\z/i))
        url         = "http://www.urbandictionary.com/define.php?term=#{CGI::escape query[1]}"
        doc         = Nokogiri::HTML open(url)
        definitions = doc.css 'div.definition'
        definition  = definitions[rand(definitions.size)].text rescue nil
        if definition
          "#{query[1]} is #{definition} (#{url})"
        else
          "I couldn't find the definition for #{query[1]}."
        end
      else
        false
      end
    end
  end
end
