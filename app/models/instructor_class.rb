class InstructorClass < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :joining_reports
  validates :class_name, :class_description, :syllabus, :presence=>true
  validates :class_name, :length=> {:minimum=> 2, :maximum=>12 }
  belongs_to :user
  belongs_to :school_admin
  has_attached_file :class_photo
  has_attached_file :syllabus_link
end

