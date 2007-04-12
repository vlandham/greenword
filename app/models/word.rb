class Word < ActiveRecord::Base
  belongs_to :test_set
  acts_as_list :scope => :test_set
  has_many :word_answers, :foreign_key => :question_id
  
  def self.find_visible
      find(:all, :conditions => ["visible = ?",true])
  end
  
end
