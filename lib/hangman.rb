class Hangman

def initialize
	print "Welcome to Hangman! Are you ready to play? [Y/N]\n"
	answer = gets.chomp.downcase
	self.word_chooser if answer == "y"
	exit if answer == "n"
end

def word_chooser
	wordlist = File.readlines "5desk.txt".strip
	wordlist.keep_if { |word| word.length > 6 && word.length < 15}
	@secret_word = wordlist.sample.downcase.split(//)
	@secret_word.pop(2)
	print "Secret word has been chosen. \n"
	@word_display = []
	@wrong_letter = []
	@incorrect_guesses = 0
	(@secret_word.length).times do |character|
		@word_display << " _ "
	end
	print @secret_word
	guess
end

def guess
	print "Please type your guess.\n"
	guess = gets.chomp.downcase
	if guess =~ /[a-z]/ && guess.length == 1
		if @word_display.include?(guess) || @wrong_letter.include?(guess)
			print "You've already guessed the letter '#{guess}'. Please enter a new letter.\n"
			self.guess
		else
			analyzer(guess)
		end
	elsif guess == "exit"
		exit
	else
		print "Please only enter a single letter.\n"
		self.guess
	end
end

def analyzer(guess)
	if @secret_word.include?(guess)
		@secret_word.each_with_index do |space, index|
			@word_display[index] = guess if space == guess
		end
		game_display(@incorrect_guesses)
	else
		@wrong_letter << guess
		@wrong_letter.sort!
		@incorrect_guesses += 1
		game_display(@incorrect_guesses)
	end
end

def game_display(incorrect_guesses)
	if @word_display == @secret_word
		puts"    ___________"
		puts"    |         |"
		puts"    |          "
		puts"    |            "
		puts"    |     \\0/   "
		puts"    |	   |	  "
		puts"    |	  / \\	  "		
		print "The secret word is '#{@secret_word.join}'.\n"
		print "Hooray! You're free to go!\n"
		print "Play again? [Y/N]"
		answer = gets.chomp.downcase
		self.word_chooser if answer == "y"
		exit if answer == "n"
	end
	case incorrect_guesses
	when 0
		puts"    ___________"
		puts"    |          "
		puts"    |          "
		puts"    |            "
		puts"    |            "
		puts"    |			  "
		puts"    |			  "
	when 1
		puts"    ___________"
		puts"    |         |"
		puts"    |          "
		puts"    |            "
		puts"    |            "
		puts"    |			  "
		puts"    |			  "
	when 2	 		
		puts"    ___________"
		puts"    |         |"
		puts"    |         0"
		puts"    |            "
		puts"    |            "
		puts"    |			  "
		puts"    |			  "
	when 3
		puts"    ___________"
		puts"    |         |"
		puts"    |         0"
		puts"    |        /   "
		puts"    |            "
		puts"    |			  "
		puts"    |			  "
	when 4
		puts"    ___________"
		puts"    |         |"
		puts"    |         0"
		puts"    |        /|  "
		puts"    |            "
		puts"    |			  "
		puts"    |			  "
	when 5
		puts"    ___________"
		puts"    |         |"
		puts"    |         0"
		puts"    |        /|\\"
		puts"    |            "
		puts"    |			  "
		puts"    |			  "
	when 6
		puts"    ___________"
		puts"    |         |"
		puts"    |         0"
		puts"    |        /|\\"
		puts"    |        /   "
		puts"    |			  "
		puts"    |			  "
	when 7
		puts"    ___________"
		puts"    |         |"
		puts"    |         0"
		puts"    |        /|\\"
		puts"    |        / \\"
		puts"    |			  "
		puts"    |			  "						
	end
	if incorrect_guesses != 7
		print "Secret word is: #{@word_display.join}\n\n"
		print "Letters not in secret word: #{@wrong_letter.join(", ")}\n\n"
		print "You have " + (7 - @incorrect_guesses).to_s + " guesses remaining.\n"
		self.guess
	else
		print "Oh no, you've been hanged!\n"
		print "The secret word was '#{@secret_word.join}'.\n"
		print "Play again? [Y/N]"
		answer = gets.chomp.downcase
		self.word_chooser if answer == "y"
		exit if answer == "n"
	end
end

end

game = Hangman.new