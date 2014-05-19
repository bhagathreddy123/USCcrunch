class StudentReport < ActiveRecord::Base
  #set_table_name "user"
  #set_primary_key :user_id
  attr_accessible  :mark, :total,:user_id,:studentreportfileuploads_attributes
   belongs_to :user
      
  has_many :studentreportfileuploads , :dependent => :destroy
  accepts_nested_attributes_for :studentreportfileuploads, :allow_destroy => true, :reject_if=>:all_blank   
end

