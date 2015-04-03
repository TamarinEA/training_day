array_of_numbers = (1..5).to_a

if !File.exist?("rand_sort_N.txt") || File.open('rand_sort_N.txt', 'r').gets.to_i >= array_of_numbers.size
  File.open('rand_sort_N.txt', 'w'){|file| file.write("0\r\n" + array_of_numbers.sort_by{rand} * ",")}
  puts "File rand_sort_N.txt was created"
end

sort_file = File.open('rand_sort_N.txt', 'r')
sort_num = sort_file.gets.to_i
sort_array = sort_file.gets.split(",")
#File.open('rand_sort_N.txt', 'w'){|file| file.write((sort_num + 1).to_s + "\r\n" + sort_array * ",")}          # после прохождения по всем номерам - создаём новую случайную сортировку
File.open('rand_sort_N.txt', 'w'){|file| file.write(((sort_num + 1) % array_of_numbers.size).to_s + "\r\n" + sort_array * ",")} # после прохождения по всем номерам - начинаем сначала

puts sort_array[sort_num]