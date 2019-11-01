# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
class Parser < Scanner
	def initialize(filename)
    	super(filename)
    	consume()
			@errors = 0
   	end

	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end

	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.type}"
					@errors += 1
      	end
      	consume()
   	end

	def program()
      	while( @lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()
      	end
				puts "There were #{@errors} parse errors found."
   	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
		end

		puts "Exiting STMT Rule"
	end

	def exp()
		puts "Entering TERM Rule"
		term()
		puts "Entering ETAIL Rule"
		etail()
		puts "Exiting EXP Rule"
	end

	def assign()
		id()
		# match the equals sign
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
		end
		match(Token::ASSGN)
		puts "Entering EXP Rule"
		exp()
		puts "Exiting ASSGN Rule"
	end

	def term()
		puts "Entering FACTOR Rule"
		factor()
		puts "Entering TTAIL Rule"
		ttail()
		puts "Exiting TERM Rule"
	end

	def etail()
		if (@lookahead.type == Token::ADDOP)
			puts "Found ADDOP token: #{@lookahead.text}"
			consume()
		elsif (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP token: #{@lookahead.text}"
			consume()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
			puts "Exiting ETAIL Rule"
			return nil
		end
		puts "Entering TERM Rule"
		term()
		puts "Entering ETAIL Rule"
		etail()
		puts "Exiting ETAIL Rule"
	end

	def factor()
		if (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN token: #{@lookahead.text}"
			consume()
			puts "Entering EXP Rule"
			exp()
			if (@lookahead.type == Token::RPAREN)
				puts "Found RPAREN token: #{@lookahead.text}"
			end
			match(Token::RPAREN)

		elsif (@lookahead.type == Token::INT)
			int()
		elsif (@lookahead.type == Token::ID)
			id()
		else
			puts "Expected ( or INT or ID found #{@lookahead.type}"
			consume()
			@errors += 1
		end
		puts "Exiting FACTOR Rule"
	end

	def ttail()
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP token: #{@lookahead.text}"
			consume()
		elsif (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP token: #{@lookahead.text}"
			consume()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
			puts "Exiting TTAIL Rule"
			return nil
		end
		puts "Entering FACTOR Rule"
		factor()
		puts "Entering TTAIL Rule"
		ttail()
		puts "Exiting TTAIL Rule"
	end

	def int()
		if (@lookahead.type == Token::INT)
			puts "Found INT token: #{@lookahead.text}"
		end
		match(Token::INT)
	end

	def id()
		if (@lookahead.type == Token::ID)
			puts "Found ID token: #{@lookahead.text}"
		end
		match(Token::ID)
	end


end
