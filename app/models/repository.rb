class Repository < ActiveRecord::Base
  has_many :milestones
  has_many :labels
  has_many :issues
  has_many :contributors
end
