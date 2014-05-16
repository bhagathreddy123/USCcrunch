class StudentReportsController < ApplicationController
  def new
    @studentreport = StudentReport.new
  end
   
  def create
    
    @studentreport = StudentReport.new(params[:student_report])
    if @studentreport.save
      flash[:notice] = "mark has been created successfully"
      redirect_to student_reports_path
    else
      render :new
    end
  end
         
    def index
    @studentreports =  StudentReport.all
      end
      def update
        respond_to do |format|
        if @studentreport.update(studentreport_params)
        format.html { redirect_to @studentreport, notice: 'mark was successfully updated.' }
        format.json { head :no_content }
        else
        format.html { render action: 'edit' }
        format.json { render json: @studentreport.errors, status: :unprocessable_entity }
      end
    end
  end
  def show
     @studentreport = StudentReport.find(params[:id])
  end 
  def destroy
    @studentreport = StudentReport.find(params[:id])
    @studentreport.destroy
    redirect_to student_reports_path
  end
end
