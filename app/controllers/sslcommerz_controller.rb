class SslcommerzController < ApplicationController
  skip_before_action :authenticate_user!, only: [:ipn]
  skip_before_action :verify_authenticity_token, only: [:success, :fail, :cancel, :ipn]

  def success
    payment = Payment.find_by(transaction_id: params[:tran_id])

    unless payment
      redirect_to dashboard_path, alert: 'Payment not found.'
      return
    end

    # Prevent duplicate processing
    if payment.successful?
      redirect_to member_payments_path, notice: 'Payment already processed.'
      return
    end

    service = SslcommerzService.new
    validation = service.validate_transaction(params[:val_id])

    if validation[:valid] && validation[:data]['amount'].to_f == payment.amount.to_f
      payment.update!(
        status: 'success',
        sslcommerz_val_id: params[:val_id],
        sslcommerz_tran_id: params[:tran_id],
        gateway_response: validation[:data].to_json
      )

      PaymentLog.log(payment, 'verified', payment.user, 'SSLCommerz payment verified', request.remote_ip)

      # Update subscription
      if payment.subscription.present?
        payment.subscription.renew!
      end

      # Confirm event registration
      if payment.event_registration.present?
        payment.event_registration.confirm!
      end

      redirect_to member_payments_path, notice: 'Payment successful!'
    else
      payment.update!(status: 'failed', gateway_response: validation[:data].to_json)
      PaymentLog.log(payment, 'failed', payment.user, 'SSLCommerz validation failed', request.remote_ip)
      redirect_to member_payments_path, alert: 'Payment verification failed.'
    end
  end

  def fail
    payment = Payment.find_by(transaction_id: params[:tran_id])
    if payment && !payment.successful?
      payment.update!(status: 'failed', gateway_response: params.to_json)
      PaymentLog.log(payment, 'failed', payment.user, 'Payment failed at gateway', request.remote_ip)
    end
    redirect_to member_payments_path, alert: 'Payment failed.'
  end

  def cancel
    payment = Payment.find_by(transaction_id: params[:tran_id])
    if payment && !payment.successful?
      payment.update!(status: 'cancelled', gateway_response: params.to_json)
      PaymentLog.log(payment, 'failed', payment.user, 'Payment cancelled by user', request.remote_ip)
    end
    redirect_to member_payments_path, alert: 'Payment cancelled.'
  end

  # IPN (Instant Payment Notification) - server-to-server callback
  def ipn
    service = SslcommerzService.new

    unless service.verify_ipn(params)
      head :bad_request
      return
    end

    payment = Payment.find_by(transaction_id: params[:tran_id])

    unless payment
      head :not_found
      return
    end

    # Idempotency: skip if already processed
    if payment.successful?
      head :ok
      return
    end

    validation = service.validate_transaction(params[:val_id])

    if validation[:valid] && validation[:data]['amount'].to_f == payment.amount.to_f
      payment.update!(
        status: 'success',
        sslcommerz_val_id: params[:val_id],
        sslcommerz_tran_id: params[:tran_id],
        gateway_response: validation[:data].to_json
      )

      PaymentLog.log(payment, 'callback_received', nil, 'IPN callback - payment verified', request.remote_ip)

      if payment.subscription.present?
        payment.subscription.renew!
      end

      if payment.event_registration.present?
        payment.event_registration.confirm!
      end
    else
      payment.update!(status: 'failed', gateway_response: validation[:data].to_json)
      PaymentLog.log(payment, 'failed', nil, 'IPN callback - validation failed', request.remote_ip)
    end

    head :ok
  end
end
