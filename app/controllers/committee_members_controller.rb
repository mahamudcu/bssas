class CommitteeMembersController < ApplicationController
  before_action :set_committee_member, only: %i[ show edit update destroy ]
  layout  'admin_layout'
  # GET /committee_members or /committee_members.json
  def index
    @committee_members = CommitteeMember.all
  end

  # GET /committee_members/1 or /committee_members/1.json
  def show
  end

  # GET /committee_members/new
  def new
    @committee_member = CommitteeMember.new
  end

  # GET /committee_members/1/edit
  def edit
  end

  # POST /committee_members or /committee_members.json
  def create
    @committee_member = CommitteeMember.new(committee_member_params)

    respond_to do |format|
      if @committee_member.save
        format.html { redirect_to @committee_member, notice: "Committee member was successfully created." }
        format.json { render :show, status: :created, location: @committee_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @committee_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /committee_members/1 or /committee_members/1.json
  def update
    respond_to do |format|
      if @committee_member.update(committee_member_params)
        format.html { redirect_to @committee_member, notice: "Committee member was successfully updated." }
        format.json { render :show, status: :ok, location: @committee_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @committee_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /committee_members/1 or /committee_members/1.json
  def destroy
    @committee_member.destroy
    respond_to do |format|
      format.html { redirect_to committee_members_url, notice: "Committee member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_committee_member
      @committee_member = CommitteeMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def committee_member_params
      params.require(:committee_member).permit(:user_id, :committee_id, :committee_designation_id, :added_by_id, :remove_by_id, :approve_by_id, :is_approved, :description)
    end
end
