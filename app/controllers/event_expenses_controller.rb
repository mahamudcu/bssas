class EventExpensesController < ApplicationController
  before_action :set_alumni_event
  before_action :set_event_expense, only: [:update, :destroy]
  before_action :check_permissions

  def create
    @event_expense = @alumni_event.event_expenses.build(event_expense_params)

    if @event_expense.save
      log_audit('create', @event_expense)
      redirect_to @alumni_event, notice: 'Expense item was successfully added.'
    else
      redirect_to @alumni_event, alert: @event_expense.errors.full_messages.join(', ')
    end
  end

  def update
    old_attributes = @event_expense.attributes

    if @event_expense.update(event_expense_params)
      log_audit('update', @event_expense, old_attributes)
      redirect_to @alumni_event, notice: 'Expense item was successfully updated.'
    else
      redirect_to @alumni_event, alert: @event_expense.errors.full_messages.join(', ')
    end
  end

  def destroy
    @event_expense.destroy
    log_audit('destroy', @event_expense)
    redirect_to @alumni_event, notice: 'Expense item was successfully deleted.'
  end

  private

  def set_alumni_event
    @alumni_event = AlumniEvent.find(params[:alumni_event_id])
  end

  def set_event_expense
    @event_expense = @alumni_event.event_expenses.find(params[:id])
  end

  def event_expense_params
    params.require(:event_expense).permit(
      :item_name, :description, :quantity, :unit_cost, :category, :vendor
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
