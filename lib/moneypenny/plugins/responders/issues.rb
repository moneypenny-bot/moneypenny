require 'json'
require 'open-uri'
require 'cgi'
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
          when /^show me ([\w\-\._]+)\/([\w\-\._]+) issues$/i #assigned to name
            repo_user = $1
            repo_name = $2
            issue_response repo_user, repo_name
          when /^show me issues$/i
            issue_response
          else
            false
          end
        end

        private
          def repository(repo_user, repo_name)
            # @cache ||= Hash.new({})
            # cached_repo = @cache.fetch(repo_user) do |key|
            #   {key => Octopi::Repository.find(:name => repo_name, :user => repo_user)}
            # end
            # @cache
            Octopi::Repository.find(:name => repo_name, :user => repo_user)
          end

          def issue_response(repo_user = config['user'], repo_name = config['repo'])
            issues = repository(repo_user, repo_name).issues.map do |i|
              issue_url = "https://github.com/#{repo_user}/#{repo_name}/issues/#{i.number}"
              " * ##{i.number}: #{i.title} - #{issue_url}"
            end.join("\n")
          rescue NoMethodError
            return "I was unable to find any issues, sir!"
          end
      end
    end
  end
end
