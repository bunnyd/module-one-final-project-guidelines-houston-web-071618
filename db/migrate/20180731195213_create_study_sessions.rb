class CreateStudySessions < ActiveRecord::Migration[5.0]
  def change
    create_table :study_sessions do |t|
        t.integer :instructor_id
        t.integer :student_id
        t.string :study_topic
        t.boolean :is_completed
    end
  end
end
