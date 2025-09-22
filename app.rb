require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect 'new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    word = WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      valid = @game.guess(letter)
      flash[:message] = 'You have already used that letter' unless valid
    rescue ArgumentError
      flash[:message] = 'Invalid guess.'
    end
    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    game_state = @game.check_win_or_lose
    if game_state == :win
      redirect '/win'
    elsif game_state == :lose
      redirect '/lose'
    end

    erb :show # You may change/remove this line
  end

  get '/win' do
    redirect '/show' if @game.check_win_or_lose != :win
    erb :win # You may change/remove this line
  end

  get '/lose' do
    redirect '/show' if @game.check_win_or_lose != :lose
    erb :lose # You may change/remove this line
  end
end
