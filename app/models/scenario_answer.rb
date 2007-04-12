class ScenarioAnswer < Answer
  belongs_to :scenario, :foreign_key => :question_id
  belongs_to :user
  
end