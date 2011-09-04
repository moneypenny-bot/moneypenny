require 'twss'

class ThatsWhatSheSaid < Moneypenny::Listener
  def self.respond( message )
    if TWSS( message)
      "That's what she said!"
    else
      false
    end
  end
end
