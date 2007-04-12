class Section < ActiveRecord::Base
  belongs_to :semester
  has_many :courses
end
