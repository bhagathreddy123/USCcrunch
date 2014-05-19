class CreateStudentReports < ActiveRecord::Migration
  def change
    create_table :student_reports do |t|
             t.integer :mark
             t.integer :total
             t.integer :user_id
            t.timestamps
    end
  end
end
