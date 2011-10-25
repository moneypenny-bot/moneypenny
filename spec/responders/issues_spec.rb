describe Moneypenny::Plugins::Responders::Issues do
  before :each do
    moneypenny = new_moneypenny_instance
    @issues = Moneypenny::Plugins::Responders::Issues.new moneypenny
  end

  describe 'help' do
    # todo:
    # the image help test is generic and could be applied to every type of responder
    # copied implementation from Responders::Image for completeness, but should be refactored I believe
    it 'should return an Array with two Strings' do
      @issues.help.should be_an_kind_of Array
      @issues.help.size.should be 2
      @issues.help[0].should be_a_kind_of String
      @issues.help[1].should be_a_kind_of String
    end
  end

  describe 'respond' do

    context 'given a message that it understands' do
      it "should respond to 'show (me) issues'" do
        VCR.use_cassette('github-issues_issues_default_repo') do
          @issues.respond("show me issues").should match /\w/
          @issues.respond("show issues").should match /\w/
        end
      end

      it "should respond to 'show (me) <user>/<repo> issues'" do
        repo_path = "brentvatne/always-has-issues"
        VCR.use_cassette('github-issues_repo_with_issues') do
          @issues.respond("show #{repo_path} issues").should match /\w/
          @issues.respond("show me #{repo_path} issues").should match /\w/
        end
      end

      it "should give information about the issues found when given a repository with open issues" do
        repo_path = "brentvatne/always-has-issues"
        successful_issues_matcher = /issue(s)? found.*? issue title text/mi
        VCR.use_cassette('github-issues_repo_with_issues') do
          @issues.respond("show #{repo_path} issues").should match successful_issues_matcher
        end
      end

      it "must say if a repository does not exist" do
        repo_path = "brentvatne/this-repo-does-not-exist"
        VCR.use_cassette('github-issues_non_existent_repo') do
          @issues.respond("show #{repo_path} issues").should match /does not exist/
        end
      end

      it "must say if a repository has no open issues" do
        repo_path = "brentvatne/never-has-issues"
        VCR.use_cassette('github-issues_repo_without_issues') do
          @issues.respond("show #{repo_path} issues").should match /unable to find/
        end
      end

      it "says if it is unable to authenticate for a repository" do
        repo_path = "unauthenticated/unauthenticated"
        VCR.use_cassette('github-issues_unauthenticated') do
          @issues.respond("show #{repo_path} issues").should match /is private/
        end
      end

      it "works with private repos given a login and token" do
        repo_path = "authenticated/authenticated"
        @issues.stubs(:config => { 'token' => 'TOKEN_STUB', 'login' => 'bar'} )
        VCR.use_cassette('github-issues_authenticated') do
          @issues.respond("show #{repo_path} issues").should match /2 issues found/
        end
      end
    end

    context 'given a message that it does not recognize' do
      it 'should return false' do
        message = stub 'message'
        @issues.respond(message).should be_false
      end
    end
  end
end
