class Label < ActiveRecord::Base
  belongs_to :repository
  has_and_belongs_to_many :issues
end
