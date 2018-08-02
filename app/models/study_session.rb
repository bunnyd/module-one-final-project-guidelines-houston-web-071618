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
end
