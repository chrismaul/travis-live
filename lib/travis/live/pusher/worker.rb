require 'sidekiq'

module Travis
  module Async
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker

        def perform(uuid, target, method, payload, params)
          Travis::Live::Pusher::Task.new(payload, params).run
        end
      end
    end
  end
end
