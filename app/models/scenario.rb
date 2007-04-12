class Scenario < ActiveRecord::Base
  belongs_to :test
  has_many :scenario_answers, :foreign_key => :question_id
  
  def self.find_visible
      find(:all, :conditions => ["visible = ?",true])
  end
  
end
