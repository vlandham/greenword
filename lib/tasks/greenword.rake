namespace :greenword do 
  
  # Here is the name and url for your first semester.  Change these to what you would like them to be.
  SEMESTER_NAME = 'Fall 07'
  SEMESTER_URL  = 'fall07' 
  
  # Here is the name and password for your first administrator.  Please at least change the password.
  # Usernames require the @ as individuals will be using their email accounts as logins.
  ADMIN_FIRST_NAME  =   'an'
  ADMIN_LAST_NAME   =   'admin'
  ADMIN_LOGIN       =   'admin@school.edu'
  ADMIN_PASSWORD    =   '$t@rBuck$'
  ADMIN_LANGUAGE    =   'en'    #use 'es' for spanish
  
  
  
  #------------------------------------------------------------------------
  # You should not have to change anything below this line.
  
  
  
  desc "Initial Greenword Setup.  Creates new semester and new admin for semester"
  task(:setup => :environment) do
    begin
      puts "Creating Semester: #{SEMESTER_NAME}"
      first_semester = Semester.new
      first_semester.name = SEMESTER_NAME
      first_semester.url = SEMESTER_URL
      first_semester.locked = false
      
      puts "Creating User: #{ADMIN_LOGIN}"
      admin = User.new
      admin.first_name = ADMIN_FIRST_NAME
      admin.last_name = ADMIN_LAST_NAME
      admin.login = ADMIN_LOGIN
      admin.password = ADMIN_PASSWORD
      admin.password_confirmation = ADMIN_PASSWORD
      admin.language = ADMIN_LANGUAGE
      
      admin.admitted = true
      admin.admin = true
      if(first_semester.valid? && admin.valid?)
        first_semester.save!
        admin.semester_id = first_semester.id
        admin.save!  
        # this creates new gallery and discussion forums for the semester
        first_semester.setup!  
        
        # Set the current_semester settings
        Settings.current_semester = first_semester.id 
      else
        e = ""
        first_semester.errors.each_full {|error| e.concat(error)}
        admin.errors.each_full {|error| e.concat(error)}
        raise e 
      end

      
    rescue
      puts "There was an error when attempting to initialize this application"
      puts "Are you certain you have run \'rake db:migrate\'?"
      puts "Error Message:"
      puts $!, "\n"
    end
  end
end