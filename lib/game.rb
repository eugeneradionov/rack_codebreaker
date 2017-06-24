class Game
  attr_reader :hints, :game_status
  attr_accessor :input, :attempts

  def initialize
    @attempts = 5
    @secret_code = generate_secret_code
    @hints = 4
  end

  def hint
    index = rand(4)
    @secret_code[index]
    @hints -= 1
  end

  def check(input)
    @input = input
    @input = @input.split('').map(&:to_i)
    if @input == @secret_code
      @game_status = :won
      return '++++'
    end

    pluses = check_pluses
    minuses = check_minuses(pluses)
    @attempts -= 1
    @game_status = :lost if @attempts < 0
    '+' * pluses + '-' * minuses
  end

  private

  def generate_secret_code
    Array.new(4) { rand(1..6) }
  end

  def check_pluses
    @zipped = @secret_code.zip(@input).delete_if { |el| el[0] == el[1] }
    @secret_code.size - @zipped.size
  end

  def check_minuses(pluses)
    @zipped = @zipped.transpose
    secret_array = @zipped[0]
    @input = @zipped[1]

    @input.each do |item|
      index = secret_array.index(item)
      secret_array.delete_at(index) if secret_array.include? item
    end

    @secret_code.size - pluses - secret_array.size
  end
end
