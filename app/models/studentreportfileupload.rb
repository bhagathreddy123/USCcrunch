class Studentreportfileupload < ActiveRecord::Base
  belongs_to :student_report
  attr_accessible :student_report_id,:document
   has_attached_file :document, :styles => {:medium => "300x300>", :thumb => "100x100>"} 
end
