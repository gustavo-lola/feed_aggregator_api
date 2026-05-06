# Ensure cookies, session and flash middlewares are present in case the app was generated as api_only
Rails.application.config.middleware.use ActionDispatch::Cookies
Rails.application.config.middleware.use ActionDispatch::Session::CookieStore, key: '_meu_back_end_session'
Rails.application.config.middleware.use ActionDispatch::Flash
