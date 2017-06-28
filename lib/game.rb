require 'yaml'

class Game
  attr_reader :hints, :game_id, :result, :hints_string, :result
  attr_accessor :input, :attempts, :game, :game_status

  FILE_NAME = 'games.yml'

  def self.find(id)
    db = File.exist?(FILE_NAME) ? YAML.load_file(FILE_NAME) : []
    db.find { |element| element.game_id == id }
  end

  def initialize
    @attempts = 5
    @secret_code = generate_secret_code
    @hints = 2
    @hints_string = ''
    @db = File.exist?(FILE_NAME) ? YAML.load_file(FILE_NAME) : []
  end

  def hint
    index = rand(4)
    @hints_string << @secret_code[index].to_s
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
    @game_status = :lost if @attempts <= 0
    @result = '+' * pluses + '-' * minuses
  end

  def save
    @db = File.exist?(FILE_NAME) ? YAML.load_file(FILE_NAME) : []
    @game_id = @db.last ? (@db.last.game_id + 1) : 0
    @db.push(self)
    save_db(@db)
  end

  def update
    @db = File.exist?(FILE_NAME) ? YAML.load_file(FILE_NAME) : []
    index = @db.index { |element| element.game_id == @game_id }
    return save unless index
    @db[index] = self
    save_db(@db)
  end

  def delete_from_file
    @db = File.exist?(FILE_NAME) ? YAML.load_file(FILE_NAME) : []
    index = @db.index { |element| element.game_id == @game_id }
    @db.delete_at(index)
    save_db(@db)
  end

  private

  def save_db(db)
    File.open(FILE_NAME, 'w') { |f| f.write(db.to_yaml) }
  end

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
