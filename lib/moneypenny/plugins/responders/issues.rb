require 'octopi'

module Moneypenny
  module Plugins
    module Responders
      class Issues < Responder
        include Octopi
        def self.default_config
          { 'user'    => 'moneypenny-bot',
            'repo'    => 'moneypenny',
            'version' => '0.1',
            'login'   => nil,
            'token'   => nil
          }
        end


        def help
          [ 'show me moneypenny-bot/moneypenny issues', 'returns a list of public issues for the specified repository' ]
        end

        def respond(message)
            case message
            when /^show (me )?([\w\-\._]+)\/([\w\-\._]+) issues$/i #assigned to name
              user = $2
              repo = $3
              issue_response_with_authentication user, repo
            when /^show (me )?issues$/i
              issue_response_with_authentication
            else
              false
            end
        end

        def issue_response_with_authentication( user = config['user'], repo = config['repo'] )
          if config['token']
            authenticated_with( :login => config['login'],
                                :token => config['token']
                             ) do
                               issue_response( user, repo )
                             end
          else
            issue_response( user, repo )
          end
        end

        def issue_url(user, repo, issue_number)
          "https://github.com/#{user}/#{repo}/issues/#{issue_number}"
        end

        def get_remote_repository(user, repo)
          @repo_cache ||= Hash.new({})
          @repo_cache[user][repo] ||= Repository.find(:name => repo, :user => user)
        end

        def issue_response( user, repo )
          repository = get_remote_repository(user, repo)
          repo_path = "#{user}/#{repo}"
          return "I was unable to find any issues in #{repo_path}!" if repository.open_issues < 1

          #todo: if open issues greater than X, only show first X
          #-- it seems to crash on large numbers

          issues = repository.issues.map do |issue|
            " * ##{issue.number}: #{issue.title} - #{issue_url(user, repo, issue.number)}"
          end
          return "#{issues.length} issue#{"s" if issues.length > 1} found:\n" + issues.join("\n")

        rescue NotFound
          return "#{repo_path} does not exist."
        rescue APIError
          return "#{repo_path} is private or github is down."
        end
      end
    end
  end
end
