require 'active_support/core_ext/benchmark'

module Travis
  module Live
    module Middleware
      class Logging
        def call(worker, message, queue, &block)
          time = Benchmark.ms do
            yield
          end
        ensure
          uuid, _, _, payload, params = *message['args']
          data = Hash.new.tap do |data|
            data['type'] = queue
            if payload['build']
              data['build'] = payload['build']['id']
            elsif message['build_id']
              data['build'] = payload['build_id']
            end

            if payload['repository']
              data['repo'] = payload['repository']['slug']
            end

            data['event'] = params['event'] if params['event']
            data['uuid'] = uuid
            data['job'] = payload['id'] if params['event'] && params['event'] =~ /^job/
            data['time'] = "%.3f" % (time/1000) if time
            data['jid'] = message['jid']
          end
          log(data)
        end

        def log(data)
          line = "event=#{data['event']}"
          line << " build=#{data['build']}" if data['build']
          line << " job=#{data['job']}" if data['job']
          line << " uuid=#{data['uuid']}"
          line << " jid=#{data['jid']}"
          line << " time=#{data['time']}" if data['time']
          Travis.logger.info(line)
        end
      end
    end
  end
end
