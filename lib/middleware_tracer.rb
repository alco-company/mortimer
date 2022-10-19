# Trace each middleware module entry/exit. Freely adapted from
# https://github.com/DataDog/dd-trace-rb/issues/368 "Trace each middleware in the Rails stack"
module MiddlewareTracer
  def call(env)
    Rails.logger.debug { "MiddleWare: entry #{self.class.name}" }
    status, headers, response = super(env)
    Rails.logger.debug { "MiddleWare: #{self.class.name}, returning with status #{status}" }
    [status, headers, response]
  end
end
