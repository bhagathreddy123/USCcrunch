class CreateInstructorClasses < ActiveRecord::Migration
  def change
    create_table :instructor_classes do |t|
      t.integer :user_id
      t.string  :syllabus_link_file_name
      t.string  :syllabus_link_content_type
      t.integer  :syllabus_link_file_size
      t.string  :class_photo_file_name
      t.string  :class_photo_content_type
      t.integer  :class_photo_file_size
      t.string  :class_theme
      t.string  :class_name
      t.text  :syllabus
      t.text  :class_description
      t.timestamps
    end
  end
end
