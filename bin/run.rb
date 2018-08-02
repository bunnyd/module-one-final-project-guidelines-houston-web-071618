require_relative '../config/environment'
#require 'tty-prompt'

def run_me
  run = true
  prompt = TTY::Prompt.new
  until(!run)
    choice = prompt.select("Select an Option", %w(Learn About Exit))

    case choice

      when "Learn"

        # puts "Please enter Student ID"
        # user_id = gets.chomp
        puts "Please enter first_name"
        first = gets.chomp
        puts "Please enter last_name"
        last = gets.chomp
        puts "Please enter grade"
        grade = gets.chomp
        # becky = Student.get_student(user_id)

        # val_grade = Student.validate_grade(grade)

        Student.new(first, last, grade)

        binding.pry
      when "About"
        printAbout # method defined below
      when "Exit"
        clearScreen
        choice = prompt.yes?("Are you sure you want to exit Super Tutor 2.0.0?")

        if choice
          run = false
        else
          #false alarm
        end#end if/else
      else
        #should never come here
        "you broke the app! That'll be $50"
    end#end of the choice case

  end
      # while run is true the program loops indefinitely and prompts the user
      # to make a series of choices. We use tty-prompt for a simple pretty way
      # to get information.

      #INIT the TTY-PROMP SHIT THING

        #======== title screen ===============
        # LEARN
        # ABOUT
        # QUIT -> run = false
        #ans = gets.chomp


        #if ans = "Learn"
        #======== Select User Type ============


        #======== Instructor options ============


        # instructor = Intructor.new("user_id")


        #======== Student options ============







end#run_me
def clearScreen
  system('clear')
end
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
  puts "=   INSTRUCTORS --->---STUDYSESSION---<---STUDENTS  ="
  puts "= Credits: Nancy Do, Scott Ungchusri                ="
  puts "====================================================="
  puts ""
end

#setup tables and stuff then run the loops
run_me
puts "Exiting the Student Instructor Portal!"
Start pry
