class JoiningReport < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :instructor_class
end
