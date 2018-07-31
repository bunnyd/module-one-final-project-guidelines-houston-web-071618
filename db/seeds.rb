require_relative '../config/environment'

students = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/678accd3ba54"))
instructors = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/d404a192d9c2"))
study_sessions = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/7fbb179f0f52"))

#============================================================================
students.each do |student_hash|
  #make new student objects with this thing
  first_name = student_hash["first_name"]
  last_name = student_hash["last_name"]
  grade = student_hash["grade"]
  binding.pry
  # THIS FUCKER NEEDS TO BE A HASH.
  new_student = Student.new(first_name: first_name,last_name: last_name,grade: grade)
  new_student.save


end

binding.pry


#============================================================================
