class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page,:student_registration,:submit_registration,:user_params]

  # GET /users or /users.json
  def index
    # User Statistics
    @total_users = User.count
    @total_registrations = User.request_students.count
    @total_alumni = User.alumnies.count
    @total_members = User.members.count
    @total_admins = User.admins.count
    @total_teachers = User.teachers.count
    @total_ex_students = User.ex_students.count

    # Recent Users (last 5)
    @recent_users = User.order(created_at: :desc).limit(5)

    # Event Statistics (if AlumniEvent exists)
    if defined?(AlumniEvent)
      @total_events = AlumniEvent.count
      @upcoming_events = AlumniEvent.upcoming.count rescue 0
      @completed_events = AlumniEvent.completed.count rescue 0
      @total_event_income = AlumniEvent.joins(:event_incomes).sum('event_incomes.amount') rescue 0
      @total_event_expense = AlumniEvent.joins(:event_expenses).sum('event_expenses.total_cost') rescue 0
      @recent_events = AlumniEvent.order(created_at: :desc).limit(5) rescue []
    else
      @total_events = 0
      @upcoming_events = 0
      @completed_events = 0
      @total_event_income = 0
      @total_event_expense = 0
      @recent_events = []
    end

    # Committee Statistics
    @total_committees = Committee.count rescue 0
    @total_committee_members = CommitteeMember.count rescue 0

    # Photo Gallery Statistics
    @total_galleries = PhotoGallery.count rescue 0

    # Recent Events (general events)
    @recent_general_events = RecentEvent.order(created_at: :desc).limit(5) rescue []

    # Monthly registration data for chart (last 12 months)
    @monthly_registrations = User.where('created_at >= ?', 12.months.ago)
                                  .group("DATE_FORMAT(created_at, '%Y-%m')")
                                  .count rescue {}

    # User role distribution for chart
    @user_role_distribution = User.group(:role).count rescue {}

    render layout: 'admin_layout'
  end

  def student_registration
    @user = User.new
    render layout: 'resistration_layout'
    # render layout: 'login_layout'
  end

  def submit_registration
    @user = User.new(user_params)
    @user.password= SecureRandom.alphanumeric(8)
    @user.role= User::ROLE[:student]
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Registration request successful submit!'
        format.html { redirect_to root_path }
      else
        format.html { redirect_to :student_registration_path, status: :unprocessable_entity }
      end
    end
  end

  def landing_page
    @setting = Setting.last
    render layout: 'landing_page_layout'
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone,:batch,:student_id,:current_company)
  end

  end
