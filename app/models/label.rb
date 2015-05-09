class Label < ActiveRecord::Base
  belongs_to :repository
  has_many :issue_labels
  has_many :issues, :through => :issue_labels
end
