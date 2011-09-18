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
          def issue_url(user, repo, issue_number)
            "https://github.com/#{user}/#{repo}/issues/#{issue_number}"
          end
          def get_remote_repository(user, repo)
            @repo_cache ||= Hash.new({})
            @repo_cache[user][repo] ||= Octopi::Repository.find(:name => repo, :user => user)
          end

          def issue_response(user = config['user'], repo = config['repo'])
            repository = get_remote_repository(user, repo)
            repo_path = "#{user}/#{repo}"
            return "I was unable to find any issues in #{repo_path}, sir!" if repository.open_issues < 1

            #todo: if open issues greater than X, only show first X
            #-- it seems to crash on large numbers
            
            issues = repository.issues.map do |issue|
              " * ##{issue.number}: #{issue.title} - #{issue_url(user, repo, issue.number)}"
            end
            return "#{issues.length} issue#{"s" if issues.length > 1} found, sir:\n" + issues.join("\n")

          rescue Octopi::NotFound
            return "Sir, #{repo_path} does not exist or is private."
          end
      end
    end
  end
end
