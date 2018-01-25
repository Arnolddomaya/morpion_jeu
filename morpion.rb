


class BoardCase
  attr_accessor :case_value

  def initialize(symbol =" ")
    @case_value = symbol
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
    #formatage pour l'affichage.
    #les %s sont remplacés par les élements de "liste"
    #agrandir l'écran pour voir la chaine de carractère complète
    "    1   2   3\n  -------------\nA | %s | %s | %s |\n  -------------\nB | %s | %s | %s |\n  -------------\nC | %s | %s | %s |\n  -------------\n" % liste

  end

  #place "symbole" dans l'emlpacement 'place'
  def put_on_bord(symbol, place)
    #on recupère l'index de la position jouée
    index=["A1","A2","A3","B1","B2","B3","C1","C2","C3"].index(place)
    #met "symbole" dans la position "index" (modification du  "BoardCase.symbol" de cette position)
    @board[index].case_value = symbol
  end
end




class Player
  attr_accessor :name, :victorious
  attr_accessor :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

class Game
  attr_accessor :player_1, :player_2, :board, :possibilities
  def initialize()
    @board = Board.new()
    #les coups possibles à jouer
    @possibilities = ["A1","A2","A3","B1","B2","B3","C1","C2","C3"]
  end


  def go
    #determine qui doit jouer
    #0 : joeur_1; 1: joeur2
    total_turn = 0
    who_plays = 0
    #contient le gagnant, retourne false si y'a pas de gagnant
    winner = false

    symbols = ["X", "O"]
    puts "===============Tic Tac Toe============="
    puts "Joueur 1, entrez votre nom"
    name_1 = gets.chomp
    puts "Joueur 2, entrez votre nom"
    name_2 = gets.chomp


    puts "#{name_1}, choisissez votre symbole (O/X)"
    symbol_1 = gets.chomp.capitalize
    #boucle infinie tant qu'il n'y a pas de coups valides
    while not ["X", "O"].include?(symbol_1)
      puts "choisissez un symbole entre X et O"
      symbol_1 = gets.chomp.capitalize
    end

    symbols.delete(symbol_1)
    symbol_2 = symbols[0]

    @player_1 = Player.new(name_1,symbol_1)
    @player_2 = Player.new(name_2, symbol_2)

    puts @board
    #tant qu'il n'y'a pas de gagnant
    #et qu'il y'a des possibilités de jeux
    while not (winner or @possibilities.length == 0)
      #récupère un gagnant s'il en a, sinon recupère false
      winner = turn(who_plays)
      #modifaction pour passé au joueur suivant
      who_plays = (1-who_plays)
      total_turn+=1

    end
    if winner
      puts "================================================"
      puts " Bravo #{winner.name}, vous avez gagné après #{total_turn} tours! "
      puts "================================================"
    else
      puts "======================================="
      puts "  Pas de gagnant, match nul!"
      puts "======================================="
    end

  end

  #A chaque tour ...
  def turn(number)
    player = [@player_1, @player_2][number]

    puts " #{player.name} à vous de jouer! "
    played = gets.chomp.upcase
    #tant que le joueur ne choisit pas une case valide
    while not @possibilities.include?(played)

      puts " #{player.name} entrez une case valide! "
      puts @possibilities
      #retour à la ligne 
      puts
      played = gets.chomp.upcase
    end
    @board.put_on_bord(player.symbol,played)
    @possibilities.delete(played)
    puts @board
    #retourne un gagnant s'il en a, sinon retourne false
    return game_over(player)
  end


  #determine la fin de la partie
  def game_over(player)
    #les différentes combinaisons gagnantes
    vic_combi = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    vic_combi.each do |victorious_case|
      #verifie si les les pions du joeurs sont dans les cases de cette combinaison gagnante
      if @board.board[victorious_case[0]].case_value+ @board.board[victorious_case[1]].case_value+ @board.board[victorious_case[2]].case_value == player.symbol*3
        #retourne le joeur s'il a gagné
        return player
      end
    end
    #on retourne false si le joueur n'a pas gagné
    return false
  end

end

Game.new.go
