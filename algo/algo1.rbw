a = [1, 2, 3, 4, 5, 6, 7, 8, 9]
puts a.inspect
puts '[2]: ' + a[2].to_s
a = a + [10]
puts '+ [10]: ' + a.inspect
a.push(11)
puts 'push(11): ' + a.inspect
a.delete_at(6)
puts 'delete [6]: ' + a.inspect
a[4] = 0
puts '[4] = 0: ' + a.inspect