class CreateStudentreportfileuploads < ActiveRecord::Migration
  def change
    create_table :studentreportfileuploads do |t|
       t.integer :student_report_id
      t.text :body
      t.string :document_content_type
      t.string :document_file_name
      t.integer :document_file_size
      t.datetime :document_updated_at  
      t.timestamps
    end
  end
end
