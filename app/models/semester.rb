class Semester < ActiveRecord::Base
  has_many :test_sets
  has_many :sections
  has_many :courses, :through => :sections
  has_many :users
  has_many :forums
  
  
  validates_presence_of :name, :url
  validates_uniqueness_of :url
  validates_length_of :url, :maximum => 8, :message => "Please use a url less than %d"
  
  
  #big nasty function that will copy the test_set over from a previous semester
  def duplicate_test_sets(new_semester_id)
    unless new_semester_id.nil?
      test_sets = self.test_sets.find(:all)
      test_sets.each do |set|
        new_set = TestSet.new(set.attributes)
        new_set.semester_id = new_semester_id
        if(new_set.save)
          # Save all the old words to new set
          old_words = set.words.find(:all)
          old_words.each do |word|
            new_word = Word.new(word.attributes)
            new_word.test_set_id = new_set.id
            new_word.show = 0
            new_word.save!
          end
          
          # save all old completions to new set
          old_completions = set.completions.find(:all)
          old_completions.each do |completion|
            new_completion = Completion.new(completion.attributes)
            new_completion.test_set_id = new_set.id
            new_completion.show = 0
            new_completion.save!
          end
          
          # save all (there should be only one) situations to new set
          old_scenario = set.scenario
          # old_scenario.each do |scenario|
            new_scenario = Scenario.new(old_scenario.attributes)
            new_scenario.test_set_id = new_set.id
            new_scenario.show = 0
            new_scenario.save!
          # end
          
        end
      end
    end
  end
  
end
