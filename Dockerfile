FROM ruby:2.1-onbuild

ENTRYPOINT [ "bundle", "exec", "je", "sidekiq", "-c", "25", "-r", "./lib/travis/live/pusher.rb", "-q", "pusher-live" ]
ENV RACK_ENV production
