require 'erb'
require_relative 'game'
require_relative 'sessions'

class Racker
  include Sessions

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/' then index
    when '/guess' then make_guess
    when '/hint' then give_hint
    when '/restart' then restart
    else
      Rack::Response.new('Not Found', 404)
    end
  end

  private

  def index
    self.game = Game.new unless game
    Rack::Response.new(render('index.html.erb'))
  end

  def make_guess
    self.guess = @request.params['guess']
    Rack::Response.new do |response|
      response.redirect('/')
    end
  end

  def give_hint
    self.hint = game.hint
    game.instance_eval { @hints -= 1 }
    Rack::Response.new do |response|
      response.redirect('/')
    end
  end

  def restart
    @request.session.clear
    Rack::Response.new do |response|
      response.redirect('/')
    end
  end

  def result
    begin
      game_result = game.check(guess)
    rescue NoMethodError
      ''
    else
      game_result
    end
  end

  def game_status
    game.game_status.to_s
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
