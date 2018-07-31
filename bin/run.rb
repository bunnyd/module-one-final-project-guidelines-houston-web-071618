require_relative '../config/environment'

students = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/678accd3ba54"))
instructors = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/d404a192d9c2"))
study_sessions = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/7fbb179f0f52"))



#================= TEST SOME SHIT OUT!!! ======================
student_f_names = students.map do |student_hash|
student_hash["first_name"]
end

student_l_names = students.map do |student_hash|
student_hash["last_name"]
end

students.map do |student_hash|
  # bob = Object.new(student_hash["first_name"],student_hash["last_name"],student_hash["grade"])
end
#================= TEST SOME SHIT OUT!!! ======================

binding.pry
puts "HELLO WORLD"
