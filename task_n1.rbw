a = [[4, 19], nil, [32, 41], 0, 0, 0, 65]
b = [234, 0, nil, [19], 21, [41, 41, 54]]

def common_elements_occurences_count(firs_array, second_array)
  count_hash = Hash.new
  (firs_array.flatten.compact & second_array.flatten.compact).each{|elem| count_hash[elem] = 0}
  (firs_array.flatten.compact + second_array.flatten.compact).each{|elem| count_hash[elem] += 1 if count_hash.key?(elem)}
  return count_hash
end

puts common_elements_occurences_count(a, b)