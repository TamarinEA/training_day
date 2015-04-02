N = (1..5).to_a

if !File.exist?("rand_sort_N.txt") || File.open('rand_sort_N.txt', 'r').gets.to_i >= N.size
  File.open('rand_sort_N.txt', 'w'){|file| file.write("0\r\n" + N.sort_by{rand} * ",")}
end

sort_file = File.open('rand_sort_N.txt', 'r')
sort_num = sort_file.gets.to_i
sort_array = sort_file.gets.split(",")
puts sort_array[sort_num]
#File.open('rand_sort_N.txt', 'w'){|file| file.write((sort_num + 1).to_s + "\r\n" + sort_array * ",")}          # после прохождения по всем номерам - создаём новую случайную сортировку
File.open('rand_sort_N.txt', 'w'){|file| file.write(((sort_num + 1)%N.size).to_s + "\r\n" + sort_array * ",")} # после прохождения по всем номерам - начинаем сначала