class SslcommerzService
  INIT_URL = '/gwprocess/v4/api.php'.freeze
  VALIDATION_URL = '/validator/api/validationserverAPI.php'.freeze

  def initialize
    @store_id = SSLCOMMERZ_CONFIG[:store_id]
    @store_passwd = SSLCOMMERZ_CONFIG[:store_passwd]
    @base_url = SSLCOMMERZ_CONFIG[:base_url]
  end

  def initiate_payment(payment, user, success_url:, fail_url:, cancel_url:, ipn_url:)
    params = {
      store_id: @store_id,
      store_passwd: @store_passwd,
      total_amount: payment.amount.to_s,
      currency: 'BDT',
      tran_id: payment.transaction_id,
      success_url: success_url,
      fail_url: fail_url,
      cancel_url: cancel_url,
      ipn_url: ipn_url,
      cus_name: user.name || 'N/A',
      cus_email: user.email || 'N/A',
      cus_phone: user.phone || 'N/A',
      cus_add1: user.address || 'N/A',
      cus_city: 'Dhaka',
      cus_country: 'Bangladesh',
      shipping_method: 'NO',
      product_name: payment.payment_type_label,
      product_category: 'Service',
      product_profile: 'non-physical-goods'
    }

    response = HTTParty.post(
      "#{@base_url}#{INIT_URL}",
      body: params,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    )

    parsed = JSON.parse(response.body) rescue nil

    if parsed && parsed['status'] == 'SUCCESS'
      { success: true, gateway_url: parsed['GatewayPageURL'], session_key: parsed['sessionkey'] }
    else
      { success: false, error: parsed&.dig('failedreason') || 'Gateway initialization failed' }
    end
  end

  def validate_transaction(val_id)
    params = {
      val_id: val_id,
      store_id: @store_id,
      store_passwd: @store_passwd,
      format: 'json'
    }

    response = HTTParty.get(
      "#{@base_url}#{VALIDATION_URL}",
      query: params
    )

    parsed = JSON.parse(response.body) rescue nil

    if parsed && parsed['status'] == 'VALID'
      { valid: true, data: parsed }
    else
      { valid: false, data: parsed }
    end
  end

  def verify_ipn(params)
    return false if params[:tran_id].blank?

    payment = Payment.find_by(transaction_id: params[:tran_id])
    return false unless payment

    # Verify amount matches
    return false if payment.amount.to_f != params[:amount].to_f

    # Verify store credentials
    params[:store_id] == @store_id
  end
end
