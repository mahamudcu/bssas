class Member::PaymentsController < ApplicationController
  before_action :require_member

  def index
    @payments = current_user.payments.includes(:alumni_event, :subscription).recent
    @active_subscription = current_user.active_subscription
    @total_paid = current_user.total_paid
    render layout: 'admin_layout'
  end

  def pay_membership
    @subscription = current_user.active_subscription
    render layout: 'admin_layout'
  end

  def create_membership_payment
    plan_type = params[:plan_type]
    amount = plan_type == 'monthly' ? membership_monthly_amount : membership_yearly_amount

    # Find or create subscription
    subscription = current_user.subscriptions.active.where(plan_type: plan_type).first
    unless subscription
      subscription = current_user.subscriptions.create!(
        plan_type: plan_type,
        amount: amount,
        status: 'active'
      )
    end

    payment_type = plan_type == 'monthly' ? 'membership_monthly' : 'membership_yearly'

    # Duplicate check
    existing = current_user.payments.where(
      payment_type: payment_type,
      status: ['pending', 'success'],
      subscription: subscription
    )
    if plan_type == 'monthly'
      existing = existing.where(payment_for_month: Date.today.beginning_of_month)
    else
      existing = existing.where(payment_for_year: Date.today.year)
    end

    if existing.exists?
      redirect_to member_payments_path, alert: 'You already have a payment for this period.'
      return
    end

    payment = current_user.payments.new(
      payment_type: payment_type,
      amount: amount,
      payment_method: 'sslcommerz',
      subscription: subscription,
      payment_for_month: plan_type == 'monthly' ? Date.today.beginning_of_month : nil,
      payment_for_year: plan_type == 'yearly' ? Date.today.year : nil
    )

    if payment.save
      PaymentLog.log(payment, 'created', current_user, 'Online membership payment initiated', request.remote_ip)
      initiate_sslcommerz(payment)
    else
      redirect_to member_pay_membership_path, alert: payment.errors.full_messages.join(', ')
    end
  end

  def pay_event
    @event = AlumniEvent.find(params[:event_id])

    if current_user.registered_for_event?(@event)
      redirect_to member_payments_path, alert: 'You are already registered for this event.'
      return
    end

    render layout: 'admin_layout'
  end

  def create_event_payment
    @event = AlumniEvent.find(params[:event_id])

    if current_user.registered_for_event?(@event)
      redirect_to member_payments_path, alert: 'You are already registered for this event.'
      return
    end

    payment = current_user.payments.new(
      payment_type: 'event_fee',
      amount: @event.registration_fee,
      payment_method: 'sslcommerz',
      alumni_event: @event
    )

    if payment.save
      EventRegistration.create!(
        user: current_user,
        alumni_event: @event,
        payment: payment,
        status: 'pending'
      )
      PaymentLog.log(payment, 'created', current_user, "Event registration payment for: #{@event.title}", request.remote_ip)
      initiate_sslcommerz(payment)
    else
      redirect_to member_pay_event_path(event_id: @event.id), alert: payment.errors.full_messages.join(', ')
    end
  end

  def events
    @events = AlumniEvent.upcoming.where('registration_fee > 0').order(event_date: :asc)
    @registered_event_ids = current_user.event_registrations.pluck(:alumni_event_id)
    render layout: 'admin_layout'
  end

  private

  def initiate_sslcommerz(payment)
    service = SslcommerzService.new
    result = service.initiate_payment(
      payment,
      current_user,
      success_url: sslcommerz_success_url,
      fail_url: sslcommerz_fail_url,
      cancel_url: sslcommerz_cancel_url,
      ipn_url: sslcommerz_ipn_url
    )

    if result[:success]
      payment.update(gateway_response: result.to_json)
      redirect_to result[:gateway_url]
    else
      payment.update(status: 'failed', gateway_response: result.to_json)
      PaymentLog.log(payment, 'failed', current_user, "Gateway init failed: #{result[:error]}", request.remote_ip)
      redirect_to member_payments_path, alert: "Payment gateway error: #{result[:error]}"
    end
  end

  def membership_monthly_amount
    500.00 # BDT - configurable
  end

  def membership_yearly_amount
    5000.00 # BDT - configurable
  end

  def require_member
    unless current_user.is_show_access?
      redirect_to dashboard_path, alert: 'Access denied.'
    end
  end
end
