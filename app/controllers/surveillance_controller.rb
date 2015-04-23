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
    github = Github.new client_id: 'ab0f000ed4fb6f13a6c6', client_secret: '049d5ef30578afac88a79ea056e17ee23d2b5a41', scope: 'repo'
    github.authorize_url scope: 'repo'
    redirect_to github.authorize_url
  end

end