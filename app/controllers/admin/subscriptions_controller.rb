class Admin::SubscriptionsController < ApplicationController
  before_action :require_admin
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  def index
    @subscriptions = Subscription.includes(:user).order(created_at: :desc)
    @subscriptions = @subscriptions.where(plan_type: params[:plan_type]) if params[:plan_type].present?
    @subscriptions = @subscriptions.where(status: params[:status]) if params[:status].present?

    render layout: 'admin_layout'
  end

  def show
    @payments = @subscription.payments.recent
    render layout: 'admin_layout'
  end

  def new
    @subscription = Subscription.new
    @users = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
    render layout: 'admin_layout'
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      redirect_to admin_subscription_path(@subscription), notice: 'Subscription created successfully.'
    else
      @users = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
      flash.now[:alert] = @subscription.errors.full_messages.join(', ')
      render :new, layout: 'admin_layout'
    end
  end

  def edit
    @users = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
    render layout: 'admin_layout'
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to admin_subscription_path(@subscription), notice: 'Subscription updated successfully.'
    else
      @users = User.where(role: [User::ROLE[:member], User::ROLE[:alumni]])
      flash.now[:alert] = @subscription.errors.full_messages.join(', ')
      render :edit, layout: 'admin_layout'
    end
  end

  def destroy
    @subscription.update(status: 'cancelled')
    redirect_to admin_subscriptions_path, notice: 'Subscription cancelled.'
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_type, :amount, :status,
                                         :start_date, :end_date, :next_due_date,
                                         :auto_renew, :notes)
  end

  def require_admin
    unless current_user.is_edit_access?
      redirect_to dashboard_path, alert: 'Access denied.'
    end
  end
end
