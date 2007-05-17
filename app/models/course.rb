class Course < ActiveRecord::Base
  belongs_to :section
  belongs_to :semester
  has_many :users
  
  validates_presence_of :name
  validates_presence_of :number
end
