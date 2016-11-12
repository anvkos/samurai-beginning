=begin
Заполнить массив числами от 10 до 100 с шагом 5
=end

start = 10
limit = 100
step = 5

numbers = (start..limit).step(step).to_a
