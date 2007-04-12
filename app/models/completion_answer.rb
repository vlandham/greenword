class CompletionAnswer < Answer
  belongs_to :completion, :foreign_key => :question_id
  belongs_to :user
end