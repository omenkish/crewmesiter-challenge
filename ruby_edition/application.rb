files = File.expand_path('../cm_challenge/**/*.rb', __FILE__ )
Dir.glob(files).each { |file| require(file) }

class Application
  def call(env)
    request = Rack::Request.new(env)
    process_request(request)
  end

  def process_request(request)
    Router.new(request).route!
  end
end
