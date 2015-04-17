a = [3,67,24,1,657,0,867,6,5,4,9,2,17,345,23]
b = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
c = ((0..10000000).to_a + (0..1000000).to_a + (0..800703).to_a + (0..700000).to_a + (0..500000).to_a)

def swap(array, i, j)
  array[i], array[j] = array[j], array[i]
end

def bubble_sort(array)
  (1...array.size).each do |i|
    swap_flag = false
    (0...(array.size - i)).each do |j|
      if array[j] > array[j + 1]
        swap(array, j, j + 1)
        swap_flag = true
      end
    end
    if swap_flag == false
      break
    end
  end
end

def insert_sort(array)
  (1...array.size).each do |i|
    j = i
    while array[j] < array[j - 1] && j > 0
      swap(array, j, j - 1)
      j -= 1
    end
  end
end

def option_sort(array)
  (0...(array.size - 1)).each do |i|
    lowest = i
    (i...array.size).each do |j|
      if array[lowest] > array[j]
        lowest = j
      end
    end
    swap(array, i, lowest)
  end
end

def take_separator(array, i, j)
  separator = i
  (i..j).each do |k|
    if array[k] > array[separator]
      separator = k
	  break
    elsif array[k] < array[separator]
      break
    else
      separator = k
    end
  end
  return separator
end

def part_of_quick_sort(array, i, j)
  if i >= j
    return
  end
  separator = take_separator(array, i, j)
  if separator == j
    return
  end
  left = separator
  right = j
  separator = array[separator]
  while left < right
    swap(array, left, right)
    while array[left] < separator
      left += 1
    end
    while array[right] >= separator
      right -= 1
    end
  end
  part_of_quick_sort(array, i, left - 1)
  part_of_quick_sort(array, left, j)
end

def quick_sort(array)
  part_of_quick_sort(array, 0, array.size - 1)
end

def give_me_sort_time(array)
  new_array = array.clone
  #sort_array_test(new_array)
  t1 = Time.now
  quick_sort(new_array)
  t2 = Time.now
  puts 'Quick sort time: ' + (t2 - t1).to_s
  sort_array_test(new_array)
  
  #puts "\r\n"
  new_array = array.clone
  #sort_array_test(new_array)
  t1 = Time.now
  new_array.sort!
  t2 = Time.now
  puts 'Ruby sort: ' + (t2 - t1).to_s
  sort_array_test(new_array)
  puts "\r\n"
end

def sort_array_test(array)
  first = array[0]
  #flag = 'good sort'
  array.each.with_index do |k, i|
    if k < first
      #flag = 'BAD sort' + array[0..i].inspect
      puts 'WARNING!!!' + array[0..i].inspect
      break
    end
    first = k
  end
  #puts flag
end

puts "Start."
c.sort_by!{rand}
sort_array_test(c)
give_me_sort_time(c)
puts "Finish."
