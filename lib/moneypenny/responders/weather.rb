require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Responders
    class Weather
      def self.respond(message)
        if message.downcase.include?('weather') && (query = message.match(/in\ (.+)\z/i))
          doc = Nokogiri::HTML open("http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{CGI::escape query[1]}")
          location    = doc.xpath('//current_observation/display_location/full').text.gsub(',', '')
          weather     = doc.xpath('//current_observation/weather').text.downcase.strip
          temperature = doc.xpath('//current_observation/temp_f').text.downcase.strip
          wind        = doc.xpath('//current_observation/wind_string').text.downcase.strip
          visibility  = doc.xpath('//current_observation/visibility_mi').text.downcase.strip
          "It's #{temperature}° in #{location}, #{weather}, wind #{wind}, #{visibility} miles visibility."
        else
          false
        end
      end
    end
  end
end
