class Semester < ActiveRecord::Base
  has_many :test_sets
  has_many :sections, :order => :position
  has_many :courses
  has_many :users
  has_many :forums
  has_many :announcements, :order => "updated_on DESC"
  has_many :documents
  has_many :links
  
  
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
          old_scenarios = set.scenarios
          # old_scenario.each do |scenario|
          old_scenarios.each do |scenario|
            new_scenario = Scenario.new(scenario.attributes)
            new_scenario.test_set_id = new_set.id
            new_scenario.show = 0
            new_scenario.save!
          end
          
        end
      end
    end
  end
  
  # This is the initial setup for when a new semester is created.
  #
  # Currently creates new disscussion and gallery forums.
  def setup!
    self.create_new_forums
  end
  
  # Creates new forums witht the correct names for the new semester. This is to make it easier to start up the new semester 
  def create_new_forums
  # create discussion forum  
   if self.forums.find_discussion.nil?
     @discussion_forum = Forum.new( :name => "Discussion", 
            :description => "This is the Discussion Fourm", :semester_id => self.id,
            :forum_type => 'dis')
     @discussion_forum.save
   end   
   #create gallery forum
   if self.forums.find_photo.nil?
     @gallery_forum = Forum.new( :name => "Gallery", 
             :description => "This is the Gallery Fourm", :semester_id => self.id,
             :forum_type => 'pho')
      @gallery_forum.save
   end  
  end

end
