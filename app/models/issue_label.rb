class IssueLabel < ActiveRecord::Base
  belongs_to :issue
  belongs_to :label
  belongs_to :repository
end
