class Course < ActiveRecord::Base
  belongs_to :section
  has_many :users
  
  validates_presence_of :name
  validates_presence_of :number
end
