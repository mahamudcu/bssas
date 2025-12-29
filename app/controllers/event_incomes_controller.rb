class EventIncomesController < ApplicationController
  before_action :set_alumni_event
  before_action :set_event_income, only: [:update, :destroy]
  before_action :check_permissions

  def create
    @event_income = @alumni_event.event_incomes.build(event_income_params)

    if @event_income.save
      log_audit('income_added', @event_income)
      redirect_to @alumni_event, notice: 'Income was successfully recorded.'
    else
      redirect_to @alumni_event, alert: @event_income.errors.full_messages.join(', ')
    end
  end

  def update
    old_attributes = @event_income.attributes

    if @event_income.update(event_income_params)
      log_audit('update', @event_income, old_attributes)
      redirect_to @alumni_event, notice: 'Income was successfully updated.'
    else
      redirect_to @alumni_event, alert: @event_income.errors.full_messages.join(', ')
    end
  end

  def destroy
    @event_income.destroy
    log_audit('income_deleted', @event_income)
    redirect_to @alumni_event, notice: 'Income was successfully deleted.'
  end

  private

  def set_alumni_event
    @alumni_event = AlumniEvent.find(params[:alumni_event_id])
  end

  def set_event_income
    @event_income = @alumni_event.event_incomes.find(params[:id])
  end

  def event_income_params
    params.require(:event_income).permit(
      :contributor_id, :income_type, :amount, :payment_method,
      :payment_date, :reference_number, :notes
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
      @alumni_event.id,
      current_user.id,
      action,
      auditable,
      changes,
      request.remote_ip
    )
  end
end
