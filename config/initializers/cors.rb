# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

# CORSとは異なるURL(オリジン)間での通信を許容する設定のこと
# 一般的にクロスオリジン間でのリソースの共有はセキュリティの観点から禁止されており、これを意図的に許容させるのがCORS
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001' # originを文字列で設定

    resource '*', # どのようなHTTPリクエストを許可するのか？をここで設定できます
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head] # 本番環境で必要のないメソッドがあれば追加しない方が安全
  end
end
