class SurveillanceController < ApplicationController

  def monitor
    # eg : https://github.com/fahad-workspace/Surveillance
    link = params[:repo]
    if link =~ /https:\/\/github.com\/(.*)\/(.*)/
      @user = link.split('/')[3]
      @repo = link.split('/')[4]
      @repo = @repo.split('.')[0]
      @oauth_token = session["access_token"]
      puts @user
      puts @repo
      github_config
      repo_list = Github.repos.list
      puts "Repo Count: #{repo_list.count}"
      repo_list.each do |repo|
        puts repo.name
      end
    end
  end

  def auth
    github_config
    url = Github.new.authorize_url + "&scope=repo"
    redirect_to url
  end

  def login
    @oauth_token = Github.new.get_token(params["code"])
    session["access_token"] = JSON.parse(@oauth_token.to_json)['access_token']
    redirect_to request.base_url
  end

  def signout
    session["access_token"] = nil
    redirect_to request.base_url
  end

  private
  def github_config
    Github.configure do |c|
      puts "THIS IS CALLED"
      c.auto_pagination = true
      c.client_id = Rails.application.config.github_client_id
      c.client_secret = Rails.application.config.github_client_secret
      if @oauth_token != nil
        c.oauth_token = @oauth_token
        puts "OAUTH: #{@oauth_token}"
      end
      if @user != nil
        c.user = @user
        puts "USER: #{@user}"
      end
      if @repo != nil
        c.repo = @repo
        puts "REPO: #{@repo}"
      end
    end
  end

end