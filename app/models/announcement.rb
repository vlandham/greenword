#Announcements are notes created by the professor that can be viewed by the student.  Announcements have one interesting option which is whether or not they are displayed on the students' front pages.  If this is not set, then the announcement is only viewable from the announcements page.
class Announcement < ActiveRecord::Base
  belongs_to :semester
  belongs_to :user

# Returns those announcements set to appear on the front page.
  def self.find_front_page
    find(:all, :conditions => ['front_page = ?', true], :order => "updated_on DESC")
  end
end
