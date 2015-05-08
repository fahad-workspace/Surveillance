class Milestone < ActiveRecord::Base
  belongs_to :repository
  has_many :issues
end
