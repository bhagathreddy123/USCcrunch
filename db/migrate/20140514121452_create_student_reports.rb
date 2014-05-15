class CreateStudentReports < ActiveRecord::Migration
  def change
    create_table :student_reports do |t|
      t.string :studentname
      t.string :studentregno
      t.string :mark1
      t.string :mark2
      t.string :mark3
      t.string :mark4
      t.string :mark5
      t.timestamps
    end
  end
end
