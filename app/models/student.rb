class Student < ActiveRecord::Base
  has_many :instructors, through: :study_sessions
  has_many :study_sessions

  def full_name
    "#{first_name} #{last_name}"
  end

  # iterate through self.all to return full name.
  def self.all_students
    all.map do |student|
      student.full_name
    end
  end

  def get_student(input_id)
    # puts "Please enter Student ID"
    # user_id = gets.chomp
    student = Student.find_by(id: input_id)
    student
  end
end
