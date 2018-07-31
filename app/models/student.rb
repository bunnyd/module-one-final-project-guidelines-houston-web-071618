class Student < ActiveRecord::Base
  has_many :instructors, through: :study_sessions
  has_many :study_sessions
end
