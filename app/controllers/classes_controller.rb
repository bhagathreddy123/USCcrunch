class ClassesController < ApplicationController
  before_filter :is_school?
  layout :get_layout

    def new
    @instructorclass = InstructorClass.new
  end
  
  def join
    @users = User.where(:role => "student")
    #@users = User.where(:role => "student").paginate(:page => params[:page], :per_page => 3)
    # @users = User.where(:role => "student").select("id, name").paginate(:page => params[:page], :per_page => 3)
    respond_to do |format|
      format.js
    end
  end
  
  def manage_join
    @instructorclass = InstructorClass.find params[:id]
    @instructorclass.update_attribute(:join,"true")
    @instructorclass.update_attribute(:user_id,current_user.id)
    redirect_to classes_path
 
    #    redirect_to classes_path()
  end
  
  
  def create
    @instructorclass = InstructorClass.new(params[:instructor_class])
    if @instructorclass.save
      flash[:notice] = "class has been created successfully"
      redirect_to classes_path
    else
      render :new
    end
  end
  
  def index
    @instructorclasses = InstructorClass.all
    puts "=============="
    puts  @instructorclasses.inspect
  end

  def switch_theme
    @user = InstructorClass.find(params[:id])
    @user.update_attribute(:class_theme, params[:url])
    render :update do |page|
    end
  end

  
  def show
    @user = InstructorClass.find(params[:id])
    @header = "Posts"
    #@posts = Tweet.where("tweet_id IS NULL and users.school_admin_id = '#{@user.user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").order("created_at Desc").paginate :per_page => 20, :page => params[:page]
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js {render :partial => "show", :layout => false if request.xhr?}
    end
  end

  def graphs
    @user = InstructorClass.find(params[:id])
    @tt = Time.now.strftime("%m/%d/%Y")
    if params[:point] == '1d'
      @datess = (Time.now - 1.day).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      @today = Time.now;
      (1..24).each do |time|
        n = 0
        p = 0
        Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").each do |user|
          if user.created_at.strftime("%H").to_i == time
            n = n+1
          end
        end
        Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").each do |user|
          if user.created_at.strftime("%H").to_i == time
            p = p+1
          end
        end
        @likesqw << [time,n]
        @likesqw1 << [time,p]
      end
    elsif params[:point] == '5d'
      @datess = (Time.now - 5.day).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      @time = Time.now.strftime("%d").to_i
      k = 0
      c = 5
      (1..5).each do |time|
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        k = k+1
        @date = (Date.today-c).strftime("%d").to_i
        @likesqw << [@date,@likes]
        @likesqw1 << [@date,@clikes]
        c = c-1
      end
    elsif params[:point] == '1m'
      @datess = (Time.now - 1.month).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      @time = Time.now.strftime("%d").to_i
      k = 0
      c = 31
      (1..31).each do |time|
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        k = k+1
        @date = (Date.today-c).strftime("%d").to_i
        @likesqw << [@date,@likes]
        @likesqw1 << [@date,@clikes]
        c = c-1
      end
    elsif params[:point] == '2m'
      @datess = (Time.now - 2.month).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      count = 0
      (1..2).each do |time|
        month = Date.today.ago(count.month).beginning_of_month
        lamonth = Date.today.ago(count.month).end_of_month
        m = Date.today.ago(count.month).beginning_of_month.strftime("%m").to_i
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth }' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @likesqw << [m,@likes]
        @likesqw1 << [m,@clikes]
        count = count+1
      end
    elsif params[:point] == '3m'
      @datess = (Time.now - 3.month).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      count = 0
      (1..3).each do |time|
        month = Date.today.ago(count.month).beginning_of_month
        lamonth = Date.today.ago(count.month).end_of_month
        m = Date.today.ago(count.month).beginning_of_month.strftime("%m").to_i
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth }' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @likesqw << [m,@likes]
        @likesqw1 << [m,@clikes]
        count = count+1
      end
    elsif params[:point] == 'all'
      @datess = (current_user.created_at).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and users.school_admin_id = '#{current_user.school_admin_id}' ").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and users.school_admin_id = '#{current_user.school_admin_id}' ").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      @date = (current_user.created_at).strftime("%Y").to_i
      @time = Date.new(@date, 1).beginning_of_month
      @time1 = Date.new(@date, 12).end_of_month
      @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@time}' AND '#{@time1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@time}' AND '#{@time1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
      @likesqw << [@date,@likes]
      @likesqw1 << [@date,@clikes]
    else
      @datess = (Time.now - 4.year).strftime("%m/%d/%Y")
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and users.school_admin_id = '#{current_user.school_admin_id}' ").joins("left join users on users.id = tweets.user_id").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and users.school_admin_id = '#{current_user.school_admin_id}' ").joins("left join users on users.id = tweets.user_id").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = favorites.user_id").count
      @likesqw = []
      @likesqw1 = []
      c = 4
      (1..5).each do |time|
        puts  @date = (Date.today).strftime("%Y").to_i-c
        @time = Date.new(@date, 1).beginning_of_month
        @time1 = Date.new(@date, 12).end_of_month
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@time}' AND '#{@time1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@time}' AND '#{@time1}' and users.school_admin_id = '#{current_user.school_admin_id}'").joins("left join users on users.id = tweets.user_id").count
        @likesqw << [@date,@likes]
        @likesqw1 << [@date,@clikes]
        c = c-1
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    
    @user = InstructorClass.find(params[:id])
    
  end

  def update
    @user = InstuctorClass.find(params[:id])
    if params[:user][:syllabus].present?
      params[:user][:syllabus_link] = nil
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully Updated your Class details."
      redirect_to class_path(:school_name => current_user.school_admin.school,:id =>@user.id)
    else
      flash[:error] = "Failed to Update your Class details."
      render :action => 'edit'
    end
  end

  def roster
    @user = InstructorClass.find(params[:id])
    @users = InstructorClass.where("role = 'student' and reset_password_token IS NULL")
  end

  def invite_students
    @user = InstructorClass.find(params[:id])
  end

  def create_invited_students
    @user = InstructorClass.find(params[:id])
    @school = SchoolAdmin.find(current_user.school_admin_id.to_i)
    user_mail = ''
    if params[:emails] != ''
      params[:emails].split(",").to_a.each do |email|
        if !User.exists?(:email => email)
          @student = @school.users.new(:email => email)
          @student.password = 'ashok123'
          @student.password_confirmation = 'ashok123'
          @student.save
          @student.update_attribute(:role, 'student')
          @student.generate_password_reset_code
          UserMailer.sent_student_invitation(@school,@student).deliver
        end
        user_mail = email
      end
      flash[:notice] = "Sent Invitation Successfully"
      redirect_to invite_students_class_path(:school_name => current_user.school_admin.school,:id =>@user.id)
    else
      flash[:error] = "Failed to Send Invitation"
      render :action => 'invite_students'
    end
  end
  
  def destroy
    @instructorclass = InstructorClass.find(params[:id])
    @instructorclass.destroy
    redirect_to classes_path
  end
  
    
end