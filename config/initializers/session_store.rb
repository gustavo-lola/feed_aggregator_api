# Use the cookie store for sessions so views/flash work correctly
Rails.application.config.session_store :cookie_store, key: "_meu_back_end_session"
