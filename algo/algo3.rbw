my_hash = {}
((('a'..'z').to_a).sort_by{rand}).each{|k| my_hash[k] = rand(100)}
puts my_hash
a = Hash[my_hash.sort]
puts a.inspect