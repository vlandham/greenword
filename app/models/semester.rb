class Semester < ActiveRecord::Base
  has_many :test_sets
  has_many :sections
  has_many :courses, :through => :sections
  has_many :users
  has_many :forums
  
end
