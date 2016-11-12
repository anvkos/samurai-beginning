=begin
Заполнить массив числами фибоначи до 100
=end

fib_numbers = []
limit = 100

fib = 0
loop do
  if fib < 2
    fib_numbers << fib
    fib += 1
  else
    fib = fib_numbers[-2] + fib_numbers[-1]
  end
  break if fib > limit
  fib_numbers << fib
end

p fib_numbers
