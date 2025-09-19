class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(new_word)
    @word = new_word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError, 'nil is not valid' unless letter
    raise ArgumentError, 'Invalid guess' if letter.match(/^[^a-zA-Z]*$/)

    letter = letter.downcase
    valid = @word.include? letter
    return false if (@guesses + @wrong_guesses).include? letter

    if valid
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    valid
  end

  # Get a word from remote "random word" service
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
