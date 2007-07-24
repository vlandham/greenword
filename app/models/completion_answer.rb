# Student response to Completion components in test-set.  
#
# Child class of Answer
class CompletionAnswer < Answer
  belongs_to :completion, :foreign_key => :question_id
  belongs_to :user
end