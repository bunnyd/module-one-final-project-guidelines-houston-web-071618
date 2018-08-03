class StudySession < ActiveRecord::Base
  belongs_to :student
  belongs_to :instructor

  # iterate through self.all to return study_topic.
  def self.all_study_topics
    topics = all.map do |session|
      session.study_topic
    end
    topics.uniq
  end
  def self.study_session_by_instructor(instructor)
    self.all.select do |session|
      session.instructor == instructor
    end
  end#instructor
  def self.study_session_by_student(student)
    self.all.select do |session|
      session.student == student
    end
  end#student
end
