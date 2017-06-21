require 'erb'
require './lib/game'

class Racker
  def self.call(env)
    new(env).response.finish
  end
end
