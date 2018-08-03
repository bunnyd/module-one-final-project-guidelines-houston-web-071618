############################
# this app pulls from an online database (google sheets) using SheetsuAPI
# and sets up a local database via ActiveRecord. Users can log in as an
# instructor or student giving them different options for setting up tutoring.
# We use tty-prompt for a simple pretty way to get information.
###

require_relative '../config/environment'


$run = true
$prompt = TTY::Prompt.new
$current_student = nil
$current_instructor = nil

def run_me
  # run = true
  # prompt = TTY::Prompt.new
  until(!$run)
    # ====== WELCOME
    welcomeMessage
    choice = $prompt.select("Select an Option", %w(Learn About Exit))
    # ====== WELCOME

    case choice

      when "Learn"#-------------------------------
        learnMenu # method defined below
      #------------------LEARN--------------------
      when "About"
        printAbout # method defined below
      #------------------ABOUT--------------------
      when "Exit"
        exitHandler
      else
        #should never come here
        "you broke the app! That'll be $50"
      #------------------EXIT--------------------
    end#end of the choice case
  end#Until loop
end#run_me

def learnMenu
  clearScreen
  choice = $prompt.select("Select your account type", %w(Instructor Student <<back<<))

  case choice

    when "Instructor"
      instructorPortal
    when "Student"
      studentPortal
    else
    #<<back<< selected goes to main loop
  end#case (choice)


end#learnMenu

def studentPortal
  #####################################
  # Asks to see if a student is new or existing.
  # new students enter their info and is checked
  # with the database to prevent duplicate accounts
  # existing students enter their name and id to login
  #
  # when a student logs in they have 3 choices
  # > create study session (limit 3 max at a time)
  # > view ONLY their own study_sessions
  # > Logout/Go back
  ##########

  choice = $prompt.select("Select an option", %w(Login Create-Account <<back<<))


  case choice

    when "Login"
      #login
      student_login
    when "Create-Account"
      #create student
      createStudent
    else
    #<<back<< selected goes to main loop
  end#case (choice)
end#end studentPortal

def student_login #------------------
  clearScreen

  #ask for user id
  #compare to database (id)
  choice = $prompt.ask("Please provide your user ID")
  $current_student = Student.get_student(choice)
    if($current_student)
      puts "Hello #{$current_student.full_name}. Welcome to something better than Learn.co"

      # SUCCESSFUL LOGIN LEADS INTO MENU WHERE $current_student can chose stuff
      studentMenu($current_student)# passes in freshly pulled instance of student
    else
      puts "YOU ARE THE WEAKEST LINK!"

    end
  #binding.pry


end#end login

def studentMenu(student)
  # Students can do one of the following:
  # > Create a study session
  # > View all their current sessions
  # > Logout ($current_student = nil)
  ####
  studentMenuRun = true
  until(!studentMenuRun)
      clearScreen
      puts "Current (StudentPortal) Login: #{student.full_name}"
      choice = $prompt.select("Please select an Option", %w(Create-Session View-Sessions Logout))

      case choice
        when "Create-Session"
          create_session(student)
        when "View-Sessions"
          view_student_sessions(student)
        else
          #logout nothing happens.
          studentMenuRun = false
      end#choice
    end#studentMenuRun
end#studentMenu

def create_session(student)
  study_topic = $prompt.ask("What study topic would you like tutoring on?", required: true)
  instructors = %w(Ginger_Beard Stephen_Austin Joanne_Fu Layla_Smith Jose_Rodriguez)
  selected_instructor = $prompt.select("Select the instructor.", instructors)
  #find the instructor

  verified_i = Instructor.get_instructor_by_name(selected_instructor.split("_").last)

  session = student.create_session(verified_i.id, student.id, study_topic)
  puts "Congratulations! you made a session!"
  $prompt.ask("hit enter to continue...")
end#create_session

def createStudent
  clearScreen
  #prompts user for first_name
  first_name = $prompt.ask("What is your first name?", required: true) do |q|
  q.validate /^[a-z ,.'-]+$/i
  end
  #prompts user for last_name
  last_name = $prompt.ask("What is your last name?", required: true) do |q|
  q.validate /^[a-z ,.'-]+$/i
  end
  #prompts user for his/her grade level and checks that is is 1-8
  grade = $prompt.ask("What is your grade level (1-8)?", required: true) do |q|
  q.validate /^[1-8]{1}$/
  end

  #verifies with the user that their input was correct
  puts "First Name: #{first_name} | Last Name: #{last_name} | Grade: #{grade}"
  verify = $prompt.yes?("Is this information correct?")

  if verify
    new_student = Student.new(first_name: first_name,last_name: last_name,grade: grade)
    if(true)#FOR TESTING. REPLACE WITH A METHODS TO COMPARE STUDENTS
      puts "Thank you #{new_student.full_name}. Your account was successfully created!"
      new_student.save
      puts "----------------------------------------------------------------------"
      puts "Your student ID is #{new_student.id}. Remember this to log in."
      puts "----------------------------------------------------------------------"

      $prompt.ask("hit enter to continue...")
    else
      puts "Sorry that account has been created already. Please pick a different name"
    end
  end

end#createStudent

def view_student_sessions(student)
  sessionArray = StudySession.study_session_by_student(student)
  puts "INSTRUCTOR NAME || STUDENT NAME || TOPIC"
  puts "----------------------------------------"
  sessionArray.each do |session|
    instr_name = Instructor.get_instructor(session.instructor_id).full_name
    student_name = Student.get_student(session.student_id).full_name
    topic = session.study_topic
    puts "#{instr_name} || #{student_name} || #{topic}"
  end
  $prompt.ask("hit enter to continue...")
end




def instructorPortal
  #####################################
  # For the purpose of this project the # of instructors doesn't
  # change. Instructors are asked to provide their "username &
  # password" for Verification. 3 failures is a boot back to the
  # beginning. successful verification then leads the instructor
  # to their commands
  #
  # an instructor can:
  # > list all instructors
  # > list all study_sessions
  # > set the status of any given study_sessions
  # > find specific study_sessions by student
  ##########
  password = $prompt.mask("Please type in the instructor password:")
  if password == "love"

    instructor_give_id
      instructorRun = true
      until(!instructorRun)
        clearScreen
        puts "Currently (InstructorPortal) logged in: #{$current_instructor.full_name}"
        choice2 = $prompt.select("Select an option", %w(View-Sessions Approve-Session Delete-Session <<back<<))


        case choice2

          when "View-Sessions"
            #View

            view_instructor_sessions($current_instructor)
          when "Approve-Session"
            #Approve

            approve_session($current_instructor)
          when "Delete-Session"
            #Delete
            delete_session($current_instructor)
          else
          #<<back<< selected goes to main loop
          instructorRun = false
        end#case (choice)
      end#until method
  else
    puts "You are not Authorized to enter the Instructor Portal, scrub!"
    $prompt.ask("hit enter to continue...")
  end#password check
end

def instructor_give_id
  clearScreen

  #ask for user id
  #compare to database (id)
  choice = $prompt.ask("Please provide your user ID")
  $current_instructor = Instructor.get_instructor(choice)
    if($current_instructor)
      puts "Hello #{$current_instructor.full_name}. Welcome to something better than Learn.co"

      # SUCCESSFUL LOGIN LEADS INTO MENU WHERE $current_student can chose stuff

    else
      puts "YOU'RE NOT IN THE DATABASE!"
      $prompt.ask("hit enter to continue...")
    end
end

def view_instructor_sessions(instructor)
  sessionArray = StudySession.study_session_by_instructor(instructor)
  puts "INSTRUCTOR NAME || STUDENT NAME || TOPIC || STATUS"
  puts "--------------------------------------------------"
  sessionArray.each do |session|
    instr_name = Instructor.get_instructor(session.instructor_id).full_name
    student_name = Student.get_student(session.student_id).full_name
    topic = session.study_topic
    status = session.is_completed
    status_text = ""
    if status == true
      status_text = "completed"
    else
      status_text = "not started"
    end

    puts "#{instr_name} || #{student_name} || #{topic} || #{status_text} "
    puts "----------------------------------------------------------------------"

  end
  $prompt.ask("hit enter to continue...")


end#view_sessions

def approve_session(instructor)
  # get all sessions with said instructor
  view_instructor_sessions(instructor)
  sessionArray = StudySession.study_session_by_instructor(instructor)
  displayArray = sessionArray.map{|session| "#{session.id},#{session.student.full_name},#{session.study_topic}"}
  approveArray = $prompt.select("Select Study Sessions to Approve:", displayArray)#per_page: 4
  sesh_id = approveArray.split(",").first


  select_session = StudySession.find_by(id: sesh_id)
  select_session.is_completed  = true
  select_session.save

  puts "You completed the session for Session ID##{sesh_id}."
  $prompt.ask("hit enter to continue...")

end#approve_session

def delete_session(instructor)
  sessionArray = StudySession.study_session_by_instructor(instructor)
  displayArray = sessionArray.map{|session| "#{session.id},#{session.student.full_name},#{session.study_topic}"}
  approveArray = $prompt.select("Select Study Sessions to Approve:", displayArray)#per_page: 4
  sesh_id = approveArray.split(",").first

  select_session = StudySession.find_by(id: sesh_id)
  select_session.is_completed  = true
  puts "You have deleted the session for Session ID##{sesh_id}."
  select_session.delete

  $prompt.ask("hit enter to continue...")

end#delete_session

def exitHandler
  clearScreen
  choice = $prompt.yes?("Are you sure you want to exit Super Tutor 2.0.0?")

  if choice
    $run = false
  end#end if/else
end#exitHandler

def clearScreen
  system('clear')
end#clearScreen

def printAbout
  clearScreen
  puts "================= SUPER TUTOR 2.0.0 ================="
  puts "= A BALLS-TO-THE-WALL TUTORING PROGRAM THAT ALLOWS  ="
  puts "= STUDENTS AND INSTRUCTORS TO CREATE AND ENGAGE IN  ="
  puts "= EDUCATIONAL ACTIVITES! THE FOLLOWING OUTLINES THE ="
  puts "= AVAILBLE OPTIONS FOR USERS:                       ="
  puts "=                                                   ="
  puts "=   STUDENTS:                                       ="
  puts "=     NEW STUDENT                                   ="
  puts "=     CURRENT STUDENT                               ="
  puts "=       > CREATE STUDY SESSION                      ="
  puts "=       > VIEW STUDY SESSION                        ="
  puts "=       > BAIL ON A SESSION  (VERSION 2.3+ ONLY)    ="
  puts "=                                                   ="
  puts "=   INSTRUCTORS: (NOW WITH PASSWORD PROTECTION)     ="
  puts "=     NEW INSTRUCTOR (PAID VERSION ONLY)            ="
  puts "=     CURRENT INSTRUCTOR                            ="
  puts "=       > VIEW STUDY SESSION                        ="
  puts "=       > APPROVE STUDY SESSION                     ="
  puts "=       > DELETE COMPLETED SESSIONS (BUGGED)        ="
  puts "=       > VIEW STUDY SESSION                        ="
  puts "=                                                   ="
  puts "=   ---------------------------------------------   ="
  puts "=                                                   ="
  puts "=          GENERAL OO RELATIONSHIP OUTLINE          ="
  puts "=                                                   ="
  puts "=  INSTRUCTORS --->---STUDYSESSION---<---STUDENTS   ="
  puts "=                                                   ="
  puts "=  Credits: Nancy Do, Scott Ungchusri               ="
  puts "====================================================="
  puts ""
  $prompt.ask("hit enter to continue")
end#printAbout

def welcomeMessage
  clearScreen
  puts "================= SUPER TUTOR 2.0.0 ================="
  puts "=    __  __                                         ="
  puts "=   / / / / Super          \"I have no idea what     ="
  puts "=  / / / /  Flatiron         I'm doing\" - Scott     ="
  puts "= /_/ /_/   Productions                             ="
  puts "=                                                   ="
  puts "====================================================="
end

#setup tables and stuff then run the loops
clearScreen
#---- FRESH START FROM HERE VVV -----
run_me
puts "Exiting the Student Instructor Portal!" # Exit message when run_me ends.
#Start pry
