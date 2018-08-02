############################
# this app pulls from an online database (google sheets) using SheetsuAPI
# and sets up a local database via ActiveRecord. Users can log in as an
# instructor or student giving them different options for setting up tutoring.
# We use tty-prompt for a simple pretty way to get information.
###

require_relative '../config/environment'


$run = true
$prompt = TTY::Prompt.new

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
    when "New-Student"
      #create student
    else
    #<<back<< selected goes to main loop
  end#case (choice)
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
end

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
  puts "=   STUDENTS:                                       ="
  puts "=     NEW STUDENT                                   ="
  puts "=     CURRENT STUDENT                               ="
  puts "=   INSTRUCTORS:                                    ="
  puts "=     NEW INSTRUCTOR                                ="
  puts "=     CURRENT INSTRUCTOR                            ="
  puts "=                                                   ="
  puts "=  INSTRUCTORS --->---STUDYSESSION---<---STUDENTS   ="
  puts "= Credits: Nancy Do, Scott Ungchusri                ="
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
