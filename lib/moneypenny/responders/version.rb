module Moneypenny
  class Version < Responder
    def self.help
      [ 'version', 'returns the current version of Moneypenny' ]
    end

    def self.respond(message)
      if (query = message.match(/\Aversion\z/i))
        root = File.join File.dirname(__FILE__), '..', '..', '..'
        if (git_sha = `cd #{root} && git rev-parse HEAD`.strip) == ''
          version = File.read(File.join(root, 'VERSION')).strip
          url     = "https://github.com/moneypenny-bot/moneypenny/tree/v#{version}"
        else
          version = git_sha[0..19]
          url     = "https://github.com/moneypenny-bot/moneypenny/tree/#{git_sha}"
        end
        "Current Moneypenny version: #{version} (#{url})"
      else
        false
      end
    end
  end
end
