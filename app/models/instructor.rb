class Instructor < ActiveRecord::Base
  has_many :students, through: :study_sessions
  has_many :study_sessions

  def full_name
    "#{first_name} #{last_name}"
  end

  # iterate through self.all to return full name.
  def self.all_instructors
    all.map do |instructor|
      instructor.full_name
    end
  end

  def get_instructor(input_id)
    # puts "Please enter Instructor ID"
    # user_id = gets.chomp
    instructor = Instructor.find_by(id: input_id)
    instructor.full_name
  end
end
