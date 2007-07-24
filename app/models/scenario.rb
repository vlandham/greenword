# Scenario component of the test-set
class Scenario < ActiveRecord::Base
  belongs_to :test_set
  acts_as_list :scope => :test_set
  has_many :scenario_answers, :foreign_key => :question_id

# Returns scenarios with visible boolean set to true.  Used in the results display  
  def self.find_visible
      find(:all, :conditions => ["visible = ?",true])
  end
  
end
