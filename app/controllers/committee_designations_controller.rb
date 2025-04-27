class CommitteeDesignationsController < ApplicationController
  before_action :set_committee_designation, only: %i[ show edit update destroy ]
  layout  'admin_layout'
  # GET /committee_designations or /committee_designations.json
  def index
    @committee_designations = CommitteeDesignation.all
  end

  # GET /committee_designations/1 or /committee_designations/1.json
  def show
  end

  # GET /committee_designations/new
  def new
    @committee_designation = CommitteeDesignation.new
  end

  # GET /committee_designations/1/edit
  def edit
  end

  # POST /committee_designations or /committee_designations.json
  def create
    @committee_designation = CommitteeDesignation.new(committee_designation_params)

    respond_to do |format|
      if @committee_designation.save
        format.html { redirect_to @committee_designation, notice: "Committee designation was successfully created." }
        format.json { render :show, status: :created, location: @committee_designation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @committee_designation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /committee_designations/1 or /committee_designations/1.json
  def update
    respond_to do |format|
      if @committee_designation.update(committee_designation_params)
        format.html { redirect_to @committee_designation, notice: "Committee designation was successfully updated." }
        format.json { render :show, status: :ok, location: @committee_designation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @committee_designation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /committee_designations/1 or /committee_designations/1.json
  def destroy
    @committee_designation.destroy
    respond_to do |format|
      format.html { redirect_to committee_designations_url, notice: "Committee designation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_committee_designation
      @committee_designation = CommitteeDesignation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def committee_designation_params
      params.require(:committee_designation).permit(:title, :description)
    end
end
