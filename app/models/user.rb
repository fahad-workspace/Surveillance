class User < ActiveRecord::Base
  has_many :repositories
end
