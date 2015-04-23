require 'net/http'

class SurveillanceController < ApplicationController

  def monitor
    # eg : https://github.com/fahad-workspace/Surveillance
    link = params[:repo]
    if link =~ /https:\/\/github.com\/(.*)\/(.*)/
      user_name = link.split('/')[3]
      repo_name = link.split('/')[4]
      repo_name = repo_name.split('.')[0]
      puts user_name
      puts repo_name
      repo_list = Github.repos.list user: user_name
      puts "Repo Count: #{repo_list.count}"
      repo_list.each do |repo|
        puts repo.name
      end
      issues = Github::Client::Issues.new
      issues.list user: user_name, repo: repo_name, state: 'open' do |issue|
        issue.labels.each do |name|
          puts name.name
        end
      end
    end
  end
  
  def auth 
    github = Github.new client_id: Rails.application.config.github_client_id, client_secret: Rails.application.config.github_client_secret
    url = github.authorize_url + "&scope=repo"
    redirect_to url
  end
  
  def login
    github = Github.new client_id: Rails.application.config.github_client_id, client_secret: Rails.application.config.github_client_secret
    token = github.get_token( params["code"] )  
    github = Github.new oauth_token: token
    redirect_to '/'
  end

end