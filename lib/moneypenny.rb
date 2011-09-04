require 'rubygems'

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'moneypenny/moneypenny'
require 'moneypenny/connections/campfire'
require 'moneypenny/connections/echo'
require 'moneypenny/responders/weather'
require 'moneypenny/responders/wikipedia'
require 'moneypenny/responders/image'
require 'moneypenny/responders/help'
require 'moneypenny/responders/define'
