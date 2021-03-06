class Faq < ActiveRecord::Base
  attr_accessible :question, :answer, :user_id,:question_document
  validates :question, :answer,:presence => true
  belongs_to :user
  has_attached_file :question_document,
    :whiny => false,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "uploaded_files/profile/:id/:style/:basename.:extension",
    :bucket => "edupost",
    :styles => {
    :original => "900x900>",
    :default => "280x190>",
    :other => "96x96>" } if (Rails.env == 'production')
  has_attached_file :question_document,:styles => {:original => "900x900>", :default => "280x190>" } if Rails.env == 'development'

  before_post_process :resize_images

  # Helper method to determine whether or not an attachment is an image.
  def image?
    question_document_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
  end

  private

  def resize_images
    return false unless image?
  end
end
