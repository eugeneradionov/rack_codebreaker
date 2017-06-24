require './lib/racker'

use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'
use Rack::Static, urls: ['/stylesheets'], root: 'public'
run Racker