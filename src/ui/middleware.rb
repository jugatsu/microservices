require 'prometheus/client'

class Metrics

  def initialize app
    @app = app
    prometheus = Prometheus::Client.registry
    @request_count = Prometheus::Client::Counter.new(:ui_request_count, 'App Request Count')
    @request_latency = Prometheus::Client::Histogram.new(:ui_request_latency_seconds, 'Request latency')
    prometheus.register(@request_latency)
    prometheus.register(@request_count)
  end

  def call env
    request_started_on = Time.now
    @status, @headers, @response = @app.call(env)
    request_ended_on = Time.now
    @request_latency.observe({ path: env['REQUEST_PATH'] }, request_ended_on - request_started_on)
    @request_count.increment({ method: env['REQUEST_METHOD'], path: env['REQUEST_PATH'], http_status: @status })
    [@status, @headers, @response]
  end

end
