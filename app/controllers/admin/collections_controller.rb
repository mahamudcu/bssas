class Admin::CollectionsController < ApplicationController
  before_action :require_admin

  def index
    @total_income = Payment.successful.sum(:amount)
    @monthly_income = Payment.successful.membership.where(payment_type: 'membership_monthly').sum(:amount)
    @yearly_income = Payment.successful.membership.where(payment_type: 'membership_yearly').sum(:amount)
    @event_income = Payment.successful.event_fees.sum(:amount)
    @pending_amount = Payment.pending_payments.sum(:amount)

    # Monthly collection data (last 12 months)
    @monthly_collections = Payment.successful
                                   .where('payments.created_at >= ?', 12.months.ago)
                                   .group("DATE_FORMAT(payments.created_at, '%Y-%m')")
                                   .sum(:amount)

    # Payment type distribution
    @payment_type_distribution = Payment.successful.group(:payment_type).sum(:amount)

    # Payment method distribution
    @payment_method_distribution = Payment.successful.group(:payment_method).sum(:amount)

    # Recent successful payments
    @recent_payments = Payment.successful.includes(:user).recent.limit(10)

    # Due members (members/alumni without active subscription)
    member_ids = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]]).pluck(:id)
    active_subscriber_ids = Subscription.active.pluck(:user_id)
    @due_member_count = (member_ids - active_subscriber_ids).count
    @paid_member_count = active_subscriber_ids.count

    # Event-wise collection
    @event_collections = AlumniEvent.joins(:event_payments)
                                     .where(payments: { status: 'success' })
                                     .group('alumni_events.id', 'alumni_events.title')
                                     .sum('payments.amount')

    render layout: 'admin_layout'
  end

  def monthly_report
    @year = params[:year]&.to_i || Date.today.year
    @monthly_data = (1..12).map do |month|
      date = Date.new(@year, month, 1)
      {
        month: date.strftime('%B'),
        total: Payment.successful.by_month(date).sum(:amount),
        membership: Payment.successful.membership.by_month(date).sum(:amount),
        event: Payment.successful.event_fees.by_month(date).sum(:amount),
        count: Payment.successful.by_month(date).count
      }
    end

    render layout: 'admin_layout'
  end

  def member_wise
    @members = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
                   .includes(:subscriptions, :payments)
                   .order(:name)

    render layout: 'admin_layout'
  end

  def event_wise
    @events = AlumniEvent.includes(:event_payments).order(event_date: :desc)
    render layout: 'admin_layout'
  end

  private

  def require_admin
    unless current_user.is_edit_access?
      redirect_to dashboard_path, alert: 'Access denied.'
    end
  end
end
