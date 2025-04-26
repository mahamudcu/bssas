class RecentEventsController < ApplicationController
  before_action :set_recent_event, only: %i[ show edit update destroy ]
  layout  'admin_layout'
  # GET /recent_events or /recent_events.json
  def index
    @recent_events = RecentEvent.all
  end

  # GET /recent_events/1 or /recent_events/1.json
  def show
  end

  # GET /recent_events/new
  def new
    @recent_event = RecentEvent.new
  end

  # GET /recent_events/1/edit
  def edit
  end

  # POST /recent_events or /recent_events.json
  def create
    @recent_event = RecentEvent.new(recent_event_params)

    respond_to do |format|
      if @recent_event.save
        format.html { redirect_to @recent_event, notice: "Recent event was successfully created." }
        format.json { render :show, status: :created, location: @recent_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recent_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recent_events/1 or /recent_events/1.json
  def update
    respond_to do |format|
      if @recent_event.update(recent_event_params)
        format.html { redirect_to @recent_event, notice: "Recent event was successfully updated." }
        format.json { render :show, status: :ok, location: @recent_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recent_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recent_events/1 or /recent_events/1.json
  def destroy
    @recent_event.destroy
    respond_to do |format|
      format.html { redirect_to recent_events_url, notice: "Recent event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recent_event
      @recent_event = RecentEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recent_event_params
      params.require(:recent_event).permit(:title, :image, :description)
    end
end
