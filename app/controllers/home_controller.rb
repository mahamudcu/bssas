class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page,:student_registration,:submit_registration,:user_params]

  # GET /users or /users.json
  def index
    render layout: 'admin_layout'
  end

  def student_registration
    @user = User.new
    render layout: 'login_layout'
  end

  def submit_registration
    @user = User.new(user_params)
    @user.password= SecureRandom.alphanumeric(8)
    @user.role= User::ROLE[:student]
    respond_to do |format|
      if @user#.save
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
    params.require(:user).permit(:name, :email, :phone)
  end

  end
