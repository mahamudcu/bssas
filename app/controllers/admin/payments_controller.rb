class Admin::PaymentsController < ApplicationController
  before_action :require_admin
  before_action :set_payment, only: [:show, :approve, :reject]

  def index
    @payments = Payment.includes(:user, :alumni_event, :subscription).recent

    # Filters
    @payments = @payments.where(status: params[:status]) if params[:status].present?
    @payments = @payments.where(payment_type: params[:payment_type]) if params[:payment_type].present?
    @payments = @payments.where(payment_method: params[:payment_method]) if params[:payment_method].present?

    if params[:month].present?
      date = Date.parse("#{params[:month]}-01")
      @payments = @payments.by_month(date)
    end

    if params[:year].present?
      @payments = @payments.by_year(params[:year].to_i)
    end

    if params[:user_id].present?
      @payments = @payments.where(user_id: params[:user_id])
    end

    @payments = @payments.page_results(params[:page])

    render layout: 'admin_layout'
  end

  def show
    @payment_logs = @payment.payment_logs.recent
    render layout: 'admin_layout'
  end

  def new
    @payment = Payment.new
    @users = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
    @events = AlumniEvent.upcoming
    render layout: 'admin_layout'
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.status = 'pending'

    if @payment.save
      PaymentLog.log(@payment, 'created', current_user, 'Manual payment created by admin', request.remote_ip)
      redirect_to admin_payment_path(@payment), notice: 'Payment created successfully.'
    else
      @users = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
      @events = AlumniEvent.upcoming
      flash.now[:alert] = @payment.errors.full_messages.join(', ')
      render :new, layout: 'admin_layout'
    end
  end

  def approve
    if @payment.approve!(current_user)
      PaymentLog.log(@payment, 'approved', current_user, 'Payment approved by admin', request.remote_ip)

      # Update subscription if membership payment
      if @payment.subscription.present?
        @payment.subscription.renew!
      end

      # Confirm event registration if event payment
      if @payment.event_registration.present?
        @payment.event_registration.confirm!
      end

      redirect_to admin_payment_path(@payment), notice: 'Payment approved successfully.'
    else
      redirect_to admin_payment_path(@payment), alert: 'Cannot approve this payment.'
    end
  end

  def reject
    if @payment.reject!(current_user)
      PaymentLog.log(@payment, 'rejected', current_user, 'Payment rejected by admin', request.remote_ip)
      redirect_to admin_payment_path(@payment), notice: 'Payment rejected.'
    else
      redirect_to admin_payment_path(@payment), alert: 'Cannot reject this payment.'
    end
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:user_id, :payment_type, :amount, :payment_method,
                                    :subscription_id, :alumni_event_id, :reference_number,
                                    :notes, :payment_for_month, :payment_for_year)
  end

  def require_admin
    unless current_user.is_edit_access?
      redirect_to dashboard_path, alert: 'Access denied.'
    end
  end
end
