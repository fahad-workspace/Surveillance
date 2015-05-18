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
      @full_repo_name = @user_login + '/' + @repo_name
      begin
        @repo_list = Octokit.repositories(@user_login)
        @issuexdata = Array.new
        @issueydata = Array.new
        @repo_list.each do |repo|
          if (repo.open_issues_count > 0)
            @issuexdata.push(repo.name)
            @issueydata.push(repo.open_issues_count)
          end
        end
        repo = Octokit.repository(@full_repo_name)
        @user = User.find_or_create_by(:github_user_id => repo.owner.id, :github_user_login => repo.owner.login, :github_user_type => repo.owner.type)
        @repository = Repository.find_or_create_by(:github_repository_id => repo.id, :name => repo.name, :full_name => repo.full_name, :private => repo.private, :created_at => repo.created_at, :updated_at => repo.updated_at, :pushed_at => repo.pushed_at, :language => repo.language, :has_issues => repo.has_issues, :open_issues_count => repo.open_issues_count, :subscribers_count => repo.subscribers_count, :user_id => @user.id)
        miles = Octokit.milestones(@full_repo_name)
        miles.each do |mile|
          @user = User.find_or_create_by(:github_user_id => mile.creator.id, :github_user_login => mile.creator.login, :github_user_type => mile.creator.type)
          @repository.milestones.find_or_create_by(:github_milestone_id => mile.id, :number => mile.number, :title => mile.title, :open_issues => mile.open_issues, :closed_issues => mile.closed_issues, :state => mile.state, :created_at => mile.created_at, :updated_at => mile.updated_at, :due_on => mile.due_on, :closed_at => mile.closed_at, :user_id => @user.id)
        end
        lbls = Octokit.labels(@full_repo_name)
        @labeldata = Array.new
        lbls.each do |lbl|
          @repository.labels.find_or_create_by(:name => lbl.name, :color => lbl.color)
        end
        contribs = Octokit.contributors(@full_repo_name)
        cmts = Octokit.commits_since(@full_repo_name, (Date.today - 15).to_s)
        @contribydata = Array.new
        @contribtotalxdata = Array.new
        @contribrecentxdata = Array.new
        contribs.each do |contrib|
          individual_commit_count = 0
          cmts.each do |cmt|
            if contrib.id == cmt.author.id
              individual_commit_count = individual_commit_count + 1
            end
          end
          if (contrib.contributions > 2 && individual_commit_count > 0)
            @contribydata.push(contrib.login)
            @contribtotalxdata.push(contrib.contributions)
            @contribrecentxdata.push(individual_commit_count)
          end
          @user = User.find_or_create_by(:github_user_id => contrib.id, :github_user_login => contrib.login, :github_user_type => contrib.type)
          @repository.contributors.find_or_create_by(:total_contributions => contrib.contributions, :recent_contributions => individual_commit_count, :user_id => @user.id)
        end
        if repo.has_issues == true
          isus = Octokit.issues(@full_repo_name)
          isus.each do |isu|
            assignee_id = nil
            milestone_id = nil
            @user = User.find_or_create_by(:github_user_id => isu.user.id, :github_user_login => isu.user.login, :github_user_type => isu.user.type)
            if !(isu.assignee.nil?)
              @assignee = User.find_or_create_by(:github_user_id => isu.assignee.id, :github_user_login => isu.assignee.login, :github_user_type => isu.assignee.type)
              assignee_id = @assignee.id
            end
            if !(isu.milestone.nil?)
              @milestone = @repository.milestones.find_by(:github_milestone_id => isu.milestone.id)
              milestone_id = @milestone.id
            end
            @issue = @repository.issues.find_or_create_by(:github_issue_id => isu.id, :number => isu.number, :title => isu.title, :state => isu.state, :issue_assignee_id => assignee_id, :milestone_id => milestone_id, :created_at => isu.created_at, :updated_at => isu.updated_at, :closed_at => isu.closed_at, :user_id => @user.id)
            isu.labels.each do |lbl|
              @label = @repository.labels.find_by(:name => lbl.name, :color => lbl.color)
              IssueLabel.find_or_create_by(:issue_id => @issue.id, :label_id => @label.id, :repository_id => @repository.id)
            end
          end
        end
        @labeldata = Array.new
        @labels = Label.where(:repository_id => @repository.id)
        @issuelabel = IssueLabel.where(:repository_id => @repository.id)
        @labels.each do |label|
          if ((IssueLabel.where(:repository_id => @repository.id, :label_id => label.id)).count > 0)
            @labeldata.push([label.name, (IssueLabel.where(:repository_id => @repository.id, :label_id => label.id)).count])
          end
        end
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