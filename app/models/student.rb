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

  def self.get_student(input_id) #takes student id and returns full name
    student = Student.find_by(id: input_id)
    student.full_name # nd to scott - maybe you can return "Hi #{the return value for this method}!" on the front-end?
  end

  # def validate_grade(grade)
  #   # validates :value, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 8 }
  #   validates :grade, :inclusion => { :in => 1..8 }
  # end

  def self.create_student(first_name, last_name, grade)
    # if validate_grade(grade)
      Student.new(first_name, last_name, grade)
    # else
    #   puts "Grade must be between 1 and 8."
    # end
  end

  def create_session(instructor_id, student_id, study_topic)
    session = StudySession.new(instructor_id, student_id, study_topic, false)
  end

  # def method_name
  #
  # end
end
