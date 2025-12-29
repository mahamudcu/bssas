class ExpensePaymentsController < ApplicationController
  before_action :set_event_expense
  before_action :set_expense_payment, only: [:destroy]
  before_action :check_permissions

  def create
    @expense_payment = @event_expense.expense_payments.build(expense_payment_params)
    @expense_payment.paid_by = current_user.id

    if @expense_payment.save
      log_audit('payment_added', @expense_payment)
      redirect_to @event_expense.alumni_event, notice: 'Payment was successfully recorded.'
    else
      redirect_to @event_expense.alumni_event, alert: @expense_payment.errors.full_messages.join(', ')
    end
  end

  def destroy
    @expense_payment.destroy
    log_audit('payment_deleted', @expense_payment)
    redirect_to @event_expense.alumni_event, notice: 'Payment was successfully deleted.'
  end

  private

  def set_event_expense
    @event_expense = EventExpense.find(params[:event_expense_id])
  end

  def set_expense_payment
    @expense_payment = @event_expense.expense_payments.find(params[:id])
  end

  def expense_payment_params
    params.require(:expense_payment).permit(
      :amount_paid, :payment_date, :payment_method, :payment_reference, :notes
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
      @event_expense.alumni_event_id,
      current_user.id,
      action,
      auditable,
      changes,
      request.remote_ip
    )
  end
end
