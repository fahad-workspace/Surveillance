class SurveillanceController < ApplicationController

  before_filter :github_config
  skip_before_filter :verify_authenticity_token, :only => [:monitor]

  def index
    if session['access_token'] != nil
      @login_name = @client.user.name
      if (@login_name == '' || @login_name == nil)
        @login_name = @client.user.login
      end
    else
      @login_name = ''
    end
  end

  def monitor
    # eg : https://github.com/fahad-workspace/Surveillance
    link = params[:repo]
    if link =~ /https:\/\/github.com\/(.*)\/(.*)/
      @user_login = link.split('/')[3]
      @repo_name = link.split('/')[4]
      @repo_name.gsub! '.git', ''
      begin
        @repo_list = Octokit.repositories(@user_login)
        @morris_data = Array.new
        @repo_list.each do |repo|
          @morris_data.push(name: repo.name, open_issues_count: repo.open_issues_count)
        end

        #######

        repo = Octokit.repository("#{@user_login}/#{@repo_name}")
        puts repo.id
        puts repo.name
        puts repo.full_name
        puts repo.private
        puts repo.created_at
        puts repo.updated_at
        puts repo.pushed_at
        puts repo.language
        puts repo.has_issues
        puts repo.open_issues_count
        puts repo.subscribers_count
        puts repo.owner.id

        Repository.find_by_created_at(:github_repository_id=>repo.id, :name=>repo.name, :full_name=>repo.full_name, :private=>repo.private, :created_at=>repo.created_at, :updated_at=>repo.updated_at, :pushed_at=>repo.pushed_at, :language=>repo.language, :has_issues=>repo.has_issues, :open_issues_count=>repo.open_issues_count, :subscribers_count=>repo.subscribers_count, :repository_owner_id=>repo.owner.id)

        #######

      rescue => e
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
    url = @client.authorize_url
    if params[:repo] == 'private'
      url = url + '&scope=repo'
    end
    redirect_to url
  end

  def login
    token = @client.exchange_code_for_token(params['code'])
    session['access_token'] = token.access_token
    redirect_to request.base_url, notice: 'Signed in!'
  end

  def signout
    session['access_token'] = nil
    redirect_to request.base_url, notice: 'Signed out!'
  end

  private
  def github_config
    Octokit.configure do |c|
      c.auto_paginate = true
      c.client_id = Rails.application.config.github_client_id
      c.client_secret = Rails.application.config.github_client_secret
      if session['access_token'] != nil
        c.access_token = session['access_token']
      end
    end
    @client = Octokit::Client.new
  end

end