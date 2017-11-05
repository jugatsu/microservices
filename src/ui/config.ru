require './ui_app'
require 'rack'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
require './middleware.rb'

use Metrics
use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

run Sinatra::Application
