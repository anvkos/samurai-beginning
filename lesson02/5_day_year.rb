=begin
Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
Найти порядковый номер даты, начиная отсчет с начала года.
Учесть, что год может быть високосным.
(Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
Алгоритм опредления високосного года: www.adm.yar.ru
=end

days_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts "Введите год:"
year = gets.chomp.to_i

puts "Введите номер месяца:"
month = gets.chomp.to_i

until month.between?(1, 12) do
  puts "Введите номер месяца от 1 до 12:"
  month = gets.chomp.to_i
end

days_months[1] = 29 if year % 400 == 0 || ( year % 4 ==0 && year % 100 != 0)

puts "Введите день:"
day = gets.chomp.to_i

until day.between?(1, days_months[month - 1]) do
  puts "В #{month} месяце #{days_months[month - 1]} дней. Введите день:"
  day = gets.chomp.to_i
end

unless month == 1
  days_months.each_with_index do |_, index|
    day += days_months[index] if index < month - 1
  end
end

puts "Это #{day} день в #{year} году"
