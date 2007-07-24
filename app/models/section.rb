class Section < ActiveRecord::Base
  belongs_to :semester
  has_many :courses
  has_many :topics
  acts_as_list :scope => :semester
end
