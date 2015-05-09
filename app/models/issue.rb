class Issue < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user
  has_many :issue_labels
  has_many :labels, :through => :issue_labels
end
