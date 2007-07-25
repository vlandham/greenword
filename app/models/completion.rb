# = Completion Class
# Holds the completion components of a test_set.  
#
# Uses acts_as_list to allow re-ordering when editing them

class Completion < ActiveRecord::Base
  belongs_to :test_set
  acts_as_list :scope => :test_set
  has_many :completion_answers, :foreign_key => :question_id
  
# Returns completions with visible boolean set to true.  Visible is used to restrict was is displayed to the students on the result section.
  def self.find_visible
      find(:all, :conditions => ["visible = ?",true])
  end
  
end
