class StudentReportsController < ApplicationController
  def new
    @studentreport = StudentReport.new
    1.times{ @studentreport.studentreportfileuploads.build}
  end
   
  def create
    @studentreport = StudentReport.new(params[:student_report])
   
    if @studentreport.save
      flash[:notice] = "mark has been created successfully"
      redirect_to student_reports_path
      1.times{ @studentreport.studentreportfileuploads.build} 
    else
      render :new
    end
  end
  
  def edit
     @studentreport = StudentReport.find(params[:id])
  end       
  
  def index
    @studentreports =  StudentReport.all
  end
#  def update
#    respond_to do |format|
#      if @studentreport.update(studentreport_params)
#        format.html { redirect_to @studentreport, notice: 'mark was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: 'edit' }
#        format.json { render json: @studentreport.errors, status: :unprocessable_entity }
#      end
#    end
#  end
  def show
    @studentreport = StudentReport.find(params[:id])
  end 
  def destroy
    @studentreport = StudentReport.find(params[:id])
    @studentreport.destroy
    redirect_to student_reports_path
  end
  
  
  def download_file
    puts "====="
    puts params[:student_report_id]
    @report = StudentReport.find(params[:student_report_id])
    file_path = @report.document_file_name
    if !file_path.nil?
      send_file "#{Rails.root}/public/system/audios/#{@report.id}/original/#{file_path}", :x_sendfile => true
    else
      redirect_to student_reports_path
    end 
     
  end
end
