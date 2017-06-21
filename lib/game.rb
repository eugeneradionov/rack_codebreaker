class Game
  attr_reader :attempts, :attempts_used
  attr_accessor :input

  def initialize
    @attempts = 5
    @attempts_used = 0
    @secret_code = generate_secret_code
  end

  def hint
    index = rand(4)
    @secret_code[index]
  end

  def check(input)
    @input = input
    @input = @input.split('').map(&:to_i)
    return '++++' if @input == @secret_code

    pluses = check_pluses
    minuses = check_minuses(pluses)
    @attempts_used += 1
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
