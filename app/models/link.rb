# Links are urls submitted by the admins and viewable in the Library by the students
class Link < ActiveRecord::Base
  belongs_to :semester
  belongs_to :user
end
