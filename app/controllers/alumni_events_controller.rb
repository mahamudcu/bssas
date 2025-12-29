class AlumniEventsController < ApplicationController
  before_action :set_alumni_event, only: [:show, :edit, :update, :destroy, :financial_summary]
  before_action :check_permissions, only: [:new, :create, :edit, :update, :destroy]
  layout  'admin_layout'
  
  def index
    @alumni_events = AlumniEvent.includes(:user).order(event_date: :desc)
    @alumni_events = @alumni_events.where(status: params[:status]) if params[:status].present?
    @alumni_events = @alumni_events.by_type(params[:event_type]) if params[:event_type].present?

    respond_to do |format|
      format.html
      format.json { render json: @alumni_events }
    end
  end

  def show
    @expenses = @alumni_event.event_expenses.includes(:expense_payments).order(created_at: :desc)
    @incomes = @alumni_event.event_incomes.includes(:contributor).order(created_at: :desc)
    @audit_logs = @alumni_event.event_audit_logs.includes(:user).recent.limit(20)
  end

  def new
    @alumni_event = AlumniEvent.new
  end

  def create
    @alumni_event = current_user.alumni_events.build(alumni_event_params)

    if @alumni_event.save
      log_audit('create', @alumni_event)
      redirect_to @alumni_event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    old_attributes = @alumni_event.attributes

    if @alumni_event.update(alumni_event_params)
      log_audit('update', @alumni_event, old_attributes)
      redirect_to @alumni_event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @alumni_event.destroy
    log_audit('destroy', @alumni_event)
    redirect_to alumni_events_url, notice: 'Event was successfully deleted.'
  end

  def financial_summary
    @summary = @alumni_event.financial_summary
    @income_by_type = @alumni_event.income_by_type
    @expenses_by_category = @alumni_event.expenses_by_category

    respond_to do |format|
      format.html
      format.json { render json: @summary }
    end
  end

  private

  def set_alumni_event
    @alumni_event = AlumniEvent.find(params[:id])
  end

  def alumni_event_params
    params.require(:alumni_event).permit(
      :title, :description, :event_date, :event_type, :location,
      :status, :budget, :registration_fee, :max_attendees
    )
  end

  def check_permissions
    unless current_user&.is_edit_access?
      redirect_to root_path, alert: 'You do not have permission to perform this action.'
    end
  end

  def log_audit(action, auditable, old_attrs = nil)
    changes = old_attrs ? auditable.attributes.to_h.diff(old_attrs) : nil
    EventAuditLog.log_action(
      auditable.id,
      current_user.id,
      action,
      auditable,
      changes,
      request.remote_ip
    )
  end
end
