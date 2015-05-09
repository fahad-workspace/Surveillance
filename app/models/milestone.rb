class Milestone < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user
  has_many :issues
end
