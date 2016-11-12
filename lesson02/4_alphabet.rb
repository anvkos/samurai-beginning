=begin
Заполнить хеш гласными буквами,
где значением будет являтся порядковый номер буквы в алфавите (a - 1).
=end

alphabet = ('а'..'я').to_a
alphabet.insert(6, 'ё')

vowels = %w(а е ё и о у ы э ю я)

letters = {}
vowels.each { |letter|  letters[letter] = alphabet.index(letter) + 1 }

p letters
