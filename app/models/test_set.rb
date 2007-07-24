class TestSet < ActiveRecord::Base
  belongs_to :semester
  has_many :completions, :order => :position, :dependent => :destroy
  has_many :words, :order => :position, :dependent => :destroy
  has_many :scenarios, :dependent => :destroy
  
  def self.find_english
    find(:first, :conditions => ["language = ?","en"])
  end
  
  def self.find_spanish
    find(:first, :conditions => ["language = ?", "es"])
  end
  
end
