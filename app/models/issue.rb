class Issue < ActiveRecord::Base
  belongs_to :repository
  has_many :issue_labels
  has_many :labels, :through => :issue_labels
end
