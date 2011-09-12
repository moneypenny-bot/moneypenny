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
            user      = $2
            repo_name = $3
            issue_response user, repo_name
          when /^show (me )?issues$/i
            issue_response
          else
            false
          end
        end

        private
          def repository(user, repo_name)
            @repo_cache ||= Hash.new({})
            @repo_cache[user][repo_name] ||= Octopi::Repository.find(:name => repo_name, :user => user)
          end

          def issue_response(user = config['user'], repo_name = config['repo'])
            issues = repository(user, repo_name).issues.map do |i|
              issue_url = "https://github.com/#{user}/#{repo_name}/issues/#{i.number}"
              " * ##{i.number}: #{i.title} - #{issue_url}"
            end.join("\n")
          rescue NoMethodError
            return "I was unable to find any issues, sir!"
          end
      end
    end
  end
end
