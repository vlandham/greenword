# Represents an actual course the students using Greenword are enrolled in.  Admins should set up course names and numbers before allowing admittance to semester. 
#
# Courses are optionally copied from previous semester when semester is duplicated.
class Course < ActiveRecord::Base
  belongs_to :section
  belongs_to :semester
  has_many :users
  
  validates_presence_of :name
  validates_presence_of :number

# Returns all courses ordered by section_id and name  
  def self.find_ordered
    find(:all, :order => "section_id, name")
  end
end
