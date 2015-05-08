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

        repository = Octokit.repository("#{@user_login}/#{@repo_name}")
        repository_db = Repository.find_or_create_by(:github_repository_id => repository.id, :name => repository.name, :full_name => repository.full_name, :private => repository.private, :created_at => repository.created_at, :updated_at => repository.updated_at, :pushed_at => repository.pushed_at, :language => repository.language, :has_issues => repository.has_issues, :open_issues_count => repository.open_issues_count, :subscribers_count => repository.subscribers_count, :repository_owner_id => repository.owner.id)

        milestones = Octokit.milestones("#{@user_login}/#{@repo_name}")
        milestones.each do |milestone|
          repository_db.milestones.find_or_create_by(:github_milestone_id => milestone.id, :number => milestone.number, :title => milestone.title, :open_issues => milestone.open_issues, :closed_issues => milestone.closed_issues, :state => milestone.state, :created_at => milestone.created_at, :updated_at => milestone.updated_at, :due_on => milestone.due_on, :closed_at => milestone.closed_at, :milestone_creator_id => milestone.creator.id)
        end

        labels = Octokit.labels("#{@user_login}/#{@repo_name}")
        labels.each do |label|
          repository_db.labels.find_or_create_by(:name => label.name, :color => label.color)
        end

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