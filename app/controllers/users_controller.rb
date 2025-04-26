class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  layout  'admin_layout'
  # GET /users or /users.json
  def index
    @users = User.admins
  end

  def request_student
    @users = User.request_students
  end

  def ex_students
    @users = User.ex_students
  end

  def alumni
    @users = User.alumnies
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def profile
    @current_user = current_user
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = User.find_by_id(profile_params[:id])
    p '>>>>>>>>>>'
    p User::ROLE[:x_student]
    p @user
    respond_to do |format|
      if @user.update(profile_params)
        format.html { redirect_to profile_path, notice: "Profile was successfully updated." }
      else
        format.html { render :edit_profile, status: :unprocessable_entity }
      end
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    p User::ROLE[:x_student]
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_show_path(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      # if user_params[:password].blank?
      #   user_params.delete(:password)
      # end
      if @user.update(user_params)
        format.html { redirect_to user_show_path(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to user_list_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :age, :phone,:email,:password,:password_confirmation,:dob,:image,:role,:is_active)
    end

  def profile_params
    params.require(:user).permit(:id, :name, :age, :phone,:email,:dob,:image,:role,:is_active)
  end

end
