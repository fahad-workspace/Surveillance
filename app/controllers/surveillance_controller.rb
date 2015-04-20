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
    end
  end
  
end