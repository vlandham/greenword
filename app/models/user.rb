require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :course
  belongs_to :semester
  has_many :word_answers
  has_many :completion_answers
  has_many :scenario_answers
  has_many :images
  has_many :posts
  
  attr_protected :admitted
  attr_protected :admin
  LANGUAGES = [
      ["English", "en"],
      ["Spanish", "es"]
    ]
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password
 
  

  validates_presence_of     :login
  validates_format_of       :login, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
                            :on => :create
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..100
  # validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_presence_of :language
  validates_inclusion_of :language, :in => LANGUAGES.map {|disp,value| value}
  
  before_save :encrypt_password
  before_save :add_email

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  
  
  def whole_name
    first_name+" "+last_name
  end
  
  def last_word
      last_answer = self.word_answers.find(:first, :order => "created_at DESC")
      result = nil  
      if(last_answer)
        result = last_answer.question_id
      end
      return result
  end
  
  def last_completion
    last_answer = self.completion_answers.find(:first, :order => "created_at DESC")
    result = nil
    if(last_answer)
      result = last_answer.question_id
    end
    return result
  end
  
   def last_scenario
     last_answer = self.scenario_answers.find(:first, :order => "created_at DESC")
     result = nil  
     if(last_answer)
       result = last_answer.question_id
     end
     return result
   end
  
  def self.find_waiting
    find(:all, :conditions => ["admitted = ?",false])
  end
  
  def self.find_students
    find(:all, :conditions =>["admin = ?", false])
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  alias display_name whole_name

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def add_email
      self.email = login
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
