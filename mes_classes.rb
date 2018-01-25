
require "pry"


class BoardCase
  attr_accessor :case_value

  def initialize(symbol =" ")
    @case_value = symbol
  end


  def to_s

  end


  def play
    #TO DO : une méthode qui change la BoardCase jouée en fonction de la valeur du joueur (X, ou O)
  end

end




class Board
  attr_accessor :board
  def initialize()
    #on remplis board de 9 cases vides
    @board = []
    9.times{ @board.push(BoardCase.new())}
  end

  def to_s
    liste = []
    @board.each{ |casebord|  liste.push(casebord.case_value)}

     " 1, 2, 3\n "+"="*8+"\n"+"%s, %s, %s\n "*3 % liste

  end

  #place "symbole" dans l'emlpacement 'place'
  def put_on_bord(symbol, place)
    place.split('')
    index = 0
    add =0
    if place[0] == 'B'
      add = 3
    elsif place[0] == 'C'
      add= 6
    else
      add= 0
    end
    index = place[1].to_i-1+ add
    @board[index].case_value = symbol
  end

end





class Player
  attr_accessor :name, :victorious
  attr_accessor :symbol

  def initialize(name, symbol)
    @name = name
    @victorious = false
    @symbol = symbol
  end

end

class Game
  attr_accessor :player_1, :player_2, :board, :possibilities
  def initialize()
    #TO DO : créé 2 joueurs, créé un board
    @board = Board.new()
    #les coups possibles à jouer
    @possibilities = ["A1","A2","A3","B1","B2","B3","C1","C2","C3"]
  end

  def go
    # TO DO : lance la partie
    #nombre total de tours joués
    turn_number = 1
    #determine qui doit jouer
    who_plays = 0
    #contient le gagnant, retourne false si y'a pas de gagnant
    winner = false

    symbols = ["X", "O"]
    puts "Joueur 1, entrez votre nom"
    name_1 = gets.chomp
    puts "Joueur 2, entrez votre nom"
    name_2 = gets.chomp


    puts "Joueur 1, choisissez votre symbole (O/X)"
    symbol_1 = gets.chomp.capitalize
    while not ["X", "O"].include?(symbol_1)
      puts "choisissez un symbole entre X et O"
      symbol_1 = gets.chomp.capitalize
    end

    symbols.delete(symbol_1)
    symbol_2 = symbols[0]

    @player_1 = Player.new(name_1,symbol_1)
    @player_2 = Player.new(name_2, symbol_2)

    #tant qu'il n'y'a pas de gagnant
    #et qu'il y'a des possibilités de jeux
    while not winner && @possibilities.length > 0
      #récupère en même temps le coup joué
      winner = turn(who_plays)
      turn_number+=1
      who_plays = (1-who_plays)

    end
    if winner
      puts "Bravo voud avez gagné #{winner.name}"
    else
      puts "Pas de gagnant, match nul"
    end

  end


  def turn(number)
    #TO DO : affiche le plateau, demande au joueur il joue quoi, vérifie si un joueur a gagné, passe au joueur suivant si la partie n'est pas finie
    player = [@player_1, @player_2][number]
    puts @board
    puts " #{player.name} à vous de jouer! "
    played = gets.chomp.upcase
    while not @possibilities.include?(played)
      puts " #{player.name} entrez une case valide! "
      puts @possibilities
      played = gets.chomp.upcase
    end
    @board.put_on_bord(player.symbol,played)
    @possibilities.delete(played)
    puts @board
    #retourne le coup joué
    return game_over(player)
  end



  def game_over(player)
    #les différente combinaisons gagnantes
    vic_combi = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    vic_combi.each do |victorious_case|
      #verifie si les les pions du joeurs sont dans les cases des combinaisons gagnates
      if @board.board[victorious_case[0]].case_value+ @board.board[victorious_case[1]].case_value+ @board.board[victorious_case[2]].case_value == player.symbol*3
        #retourne le joeur s'il a gagné
        return player
      end
      #on retourne false si le joueur n'a pas gagné

    end
    return false
  end

end

Game.new.go
