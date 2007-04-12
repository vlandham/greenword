class WordAnswer < Answer
  belongs_to :word, :foreign_key => :question_id
  belongs_to :user
  
end
