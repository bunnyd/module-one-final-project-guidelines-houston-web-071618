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

  def self.get_instructor(input_id) #takes instructor id and returns full name
    instructor = Instructor.find_by(id: input_id)
    instructor.full_name
  end

  # def self.get_sessions
  #
  # end
end
