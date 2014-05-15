class AddSubjectNameToInstructorClass < ActiveRecord::Migration
  def change
    add_column :users, :subject_name, :string
  end
end
