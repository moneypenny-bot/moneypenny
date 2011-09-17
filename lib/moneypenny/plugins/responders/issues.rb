require 'octopi'

module Moneypenny
  module Plugins
    module Responders
      class Issues < Responder
        def self.default_config
          { 'user'    => 'moneypenny-bot',
            'repo'    => 'moneypenny',
            'version' => '0.1' }
        end


        def help
          [ 'show me moneypenny-bot/moneypenny issues', 'returns a list of public issues for the specified repository' ]
        end

        def respond(message)
          case message
          when /^show (me )?([\w\-\._]+)\/([\w\-\._]+) issues$/i #assigned to name
            user = $2
            repo = $3
            issue_response user, repo
          when /^show (me )?issues$/i
            issue_response
          else
            false
          end
        end

        private
          def repository(user, repo)
            @repo_cache ||= Hash.new({})
            @repo_cache[user][repo] ||= Octopi::Repository.find(:name => repo, :user => user)
          end

          def issue_response(user = config['user'], repo = config['repo'])
            repo_path = "#{user}/#{repo}"
            issues = repository(user, repo).issues.map do |i|
              issue_url = "https://github.com/#{repo_path}/issues/#{i.number}"
              " * ##{i.number}: #{i.title} - #{issue_url}"
            end
            issues = "#{issues.length} issue#{"s" if issues.length > 1} found, sir:\n" + issues.join("\n")
          rescue Octopi::NotFound
            return "Sir, #{repo_path} does not exist or is private."
          rescue NoMethodError => e
            # this is an unfortunate quirk of the API: a repo without issues
            # causes Octopi to raise a NoMethodError
            return "I was unable to find any issues in #{repo_path}, sir!"
          end
      end
    end
  end
end
