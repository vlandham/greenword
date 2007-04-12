class Completion < ActiveRecord::Base
  belongs_to :test_set
  acts_as_list :scope => :test_set
  has_many :completion_answers, :foreign_key => :question_id
  
  def self.find_visible
      find(:all, :conditions => ["visible = ?",true])
  end
  
end
