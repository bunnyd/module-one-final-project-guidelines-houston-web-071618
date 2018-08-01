require_relative '../config/environment'

# STUDENTS============================================================================
def seed_students
  students = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/678accd3ba54"))

  students.each do |student_hash|
    #make new student objects with this thing
    first_name = student_hash["first_name"]
    last_name = student_hash["last_name"]
    grade = student_hash["grade"]
    # binding.pry
    # THIS FUCKER NEEDS TO BE A HASH.
    new_student = Student.new(first_name: first_name,last_name: last_name,grade: grade)
    new_student.save
  end
end

# INSTRUCTORS==========================================================================
def seed_instructors
  instructors = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/d404a192d9c2"))

  instructors.each do |instructor_hash|
    first_name = instructor_hash["first_name"]
    last_name = instructor_hash["last_name"]
    specialty = instructor_hash["specialty"]

    new_instructor = Instructor.new(first_name: first_name, last_name: last_name, specialty: specialty)
    new_instructor.save
  end
end
# STUDY_SESSIONS==========================================================================

def seed_study_sessions
  study_sessions = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/7fbb179f0f52"))

  study_sessions.each do |study_sessions_hash|
    instructor_id = study_sessions_hash["instructor_id"]
    student_id = study_sessions_hash["student_id"]
    study_topic = study_sessions_hash["study_topic"]
    is_completed = study_sessions_hash["is_completed"]

    new_session = StudySession.new(instructor_id: instructor_id, student_id: student_id, study_topic: study_topic, is_completed: is_completed)
    new_session.save
  end
end

seed_students
seed_instructors
seed_study_sessions
binding.pry


#============================================================================
