class SurveillanceController < ApplicationController

  before_filter :github_config
  skip_before_filter :verify_authenticity_token, :only => [:monitor]

  def index
    if session['access_token'] != nil
      @login_name = @client.user.login
    else
      @login_name = ''
    end
  end

  def monitor
    # eg : https://github.com/fahad-workspace/Surveillance
    link = params[:repo]
    if link =~ /https:\/\/github.com\/(.*)\/(.*)/
      @user = link.split('/')[3]
      @repo = link.split('/')[4]
      @repo = @repo.split('.')[0]
      begin
        @repo_list = Octokit.repositories(@user)
        @morris_data = Array.new
        @repo_list.each do |repo|
          @morris_data.push(name: repo.name, open_issues_count: repo.open_issues_count)
        end
        # binding.pry
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
    session['access_token'] = token.access_tokenl
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