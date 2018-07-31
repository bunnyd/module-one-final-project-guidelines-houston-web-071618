require_relative '../config/environment'

students = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/678accd3ba54"))
instructors = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/d404a192d9c2"))
study_sessions = JSON.parse(RestClient.get("https://sheetsu.com/apis/v1.0su/7fbb179f0f52"))
binding.pry

puts "HELLO WORLD"
