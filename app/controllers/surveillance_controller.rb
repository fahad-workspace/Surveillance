class SurveillanceController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:monitor]

  def monitor
    # eg : https://github.com/fahad-workspace/Surveillance
    link = params[:repo]
    if link =~ /https:\/\/github.com\/(.*)\/(.*)/
      @user = link.split('/')[3]
      @repo = link.split('/')[4]
      @repo = @repo.split('.')[0]
      github_config
      begin
        @repo_list = Github.repos.list
          # @commits = Github.repos.commits.list @user, @repo
          # @commits.each do |commit|
          #   puts commit.commit.message
          # end
      rescue Github::Error::GithubError => e
        flash[:error] = e.message
      end
    else
      if link.length == 0
        flash.now[:error] = 'No repository link provided!'
      else
        flash.now[:error] = 'Invalid repository link provided!'
      end
    end
  end

  def auth
    github_config
    url = Github.new.authorize_url
    if params[:repo] == 'private'
      url = url + '&scope=repo'
    end
    redirect_to url
  end

  def login
    github_config
    token = Github.new.get_token(params['code'])
    session['access_token'] = token.token
    redirect_to request.base_url, notice: 'Signed in!'
  end

  def signout
    session['access_token'] = nil
    redirect_to request.base_url, notice: 'Signed out!'
  end

  private
  def github_config
    Github.configure do |c|
      c.auto_pagination = true
      c.client_id = Rails.application.config.github_client_id
      c.client_secret = Rails.application.config.github_client_secret
      if session['access_token'] != nil
        c.oauth_token = session['access_token']
      end
      if @user != nil
        c.user = @user
      end
      if @repo != nil
        c.repo = @repo
      end
    end
  end

end