class Hangman

def initialize
	print "Welcome to Hangman! Are you ready to play? [Y/N]\n"
	answer = gets.chomp.downcase
	menu if answer == "y"
	exit if answer == "n"
end

def menu
	print "Game Commands:\n"
	print "'New' will begin a new game.\n"
	print "'Continue' will continue your current game.\n"
	print "'Save' will save your current game.\n"
	print "'Load' will load a saved game.\n"
	print "'Exit' will exit the program.\n"
	print "'Help' will display game commands.\n"
	input = gets.chomp.downcase
	case input
		when "new"
			print "New game begun.\n"
			word_chooser
		when "continue"
			if @secret_word == nil
				print ">>No game available to continue.\n"
				menu
			else
				guess
			end
		when "save"
			if @secret_word == nil
				print ">>No game available to save.\n"
				menu
			else
				print "What would you like to call your save file? (excluding extension)\n"
				savename = gets.chomp
				save(savename) if savename != "guess"
			end
		when "load"
			print "What is your save file called? (excluding extension)\n"
			savename = gets.chomp
			load(savename)
		when "exit"
			print "Exiting Hangman.\n"
			exit
		when "help"
			menu
		else
			print "Command not recognized.\n"
			menu
		end
end

def word_chooser
	wordlist = File.readlines "../5desk.txt".strip
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
	guess
end

def guess
	print "Please type your guess. You can also enter 'help' to return to the menu.\n"
	guess = gets.chomp.downcase
	if guess =~ /[a-z]/ && guess.length == 1
		if @word_display.include?(guess) || @wrong_letter.include?(guess)
			print "You've already guessed the letter '#{guess}'. Please enter a new letter.\n"
			self.guess
		else
			analyzer(guess)
		end
	elsif guess == "help"
		menu
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

def save(savename)
	File.open("../saves/#{savename}.txt", "w") do |to_file|
		Marshal.dump(@secret_word, to_file)
		Marshal.dump(@word_display, to_file)
		Marshal.dump(@wrong_letter, to_file)
		Marshal.dump(@incorrect_guesses, to_file)
	end
	print "Game has been saved as '#{savename}.txt'.\n"
	game_display(@incorrect_guesses)
end

def load(savename)
	if File.exist?("../saves/#{savename}.txt")
		File.open("../saves/#{savename}.txt", "r") do |from_file|
			@secret_word = Marshal.load(from_file)
			@word_display = Marshal.load(from_file)
			@wrong_letter = Marshal.load(from_file)
			@incorrect_guesses = Marshal.load(from_file)
		end
	print "Game file '#{savename}.txt' has been loaded.\n"
	game_display(@incorrect_guesses)
	else
		print "Unable to locate a save with that name. Here are current save files:\n"
		print "(Type 'guess' to return to current game.)\n"
		puts Dir.glob('../saves/*.txt').join(",\n")
		savename = gets.chomp
		guess if savename == "guess"
		load(savename)
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
		@secret_word = nil
		answer = gets.chomp.downcase
		menu if answer == "y"
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