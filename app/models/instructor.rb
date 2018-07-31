class Instructor < ActiveRecord::Base
  has_many :students, through: :study_sessions
  has_many :study_sessions
end
