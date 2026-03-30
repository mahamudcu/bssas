SSLCOMMERZ_CONFIG = {
  store_id: ENV.fetch('SSLCOMMERZ_STORE_ID', 'testbox'),
  store_passwd: ENV.fetch('SSLCOMMERZ_STORE_PASSWD', 'qwerty'),
  sandbox: ENV.fetch('SSLCOMMERZ_SANDBOX', 'true') == 'true',
  base_url: ENV.fetch('SSLCOMMERZ_SANDBOX', 'true') == 'true' ?
    'https://sandbox.sslcommerz.com' : 'https://securepay.sslcommerz.com'
}.freeze
