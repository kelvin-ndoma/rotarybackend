# config/initializers/session_store.rb
Rails.application.config.session_store :cookie_store, key: "_rotary", domain: :all, tld_length: 2
