class Admin::TransactionsController < ApplicationController
  before_action :require_admin

  def index
    @transactions = Payment.includes(:user, :alumni_event, :approved_by).order(created_at: :desc)

    @transactions = @transactions.where(status: params[:status]) if params[:status].present?
    @transactions = @transactions.where(payment_type: params[:payment_type]) if params[:payment_type].present?
    @transactions = @transactions.where(payment_method: params[:payment_method]) if params[:payment_method].present?

    if params[:date_from].present?
      @transactions = @transactions.where('payments.created_at >= ?', params[:date_from].to_date.beginning_of_day)
    end
    if params[:date_to].present?
      @transactions = @transactions.where('payments.created_at <= ?', params[:date_to].to_date.end_of_day)
    end

    if params[:search].present?
      @transactions = @transactions.joins(:user)
                                    .where('users.name LIKE ? OR payments.transaction_id LIKE ?',
                                           "%#{params[:search]}%", "%#{params[:search]}%")
    end

    render layout: 'admin_layout'
  end

  private

  def require_admin
    unless current_user.is_edit_access?
      redirect_to dashboard_path, alert: 'Access denied.'
    end
  end
end
