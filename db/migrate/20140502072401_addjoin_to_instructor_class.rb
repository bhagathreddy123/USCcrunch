class AddjoinToInstructorClass < ActiveRecord::Migration
def change
    add_column :instructor_classes, :join, :boolean, :default => false
end
end
