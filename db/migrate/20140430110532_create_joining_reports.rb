class CreateJoiningReports < ActiveRecord::Migration
  def change
    create_table :joining_reports do |t|
      t.boolean :mon
      t.boolean :tue
      t.boolean :wed
      t.boolean :thu
      t.boolean :fri
      t.boolean :sat
      t.boolean :sun
      t.integer :user_id
      t.integer :instructor_class_id
      t.timestamps
    end
  end
end

