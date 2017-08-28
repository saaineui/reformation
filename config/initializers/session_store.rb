# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, 
  key: '_reformation_session',
  secure: Rails.env.production?, # require encryption in production
  httponly: true # should be true by default 
