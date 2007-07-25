# Base class for answers.  All answers (word_answer, situation_answer, and scenario_answer) are stored in the same table.  This is done using 'single table inheritence'.  
#
# You will note that the above answer classes are all sub-classes of this class Answer.

class Answer < ActiveRecord::Base
  belongs_to :user
   validates_presence_of  :value
end