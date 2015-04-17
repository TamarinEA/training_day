def swap(array, i, j)
  array[i], array[j] = array[j], array[i]
end

def take_separator(array, i, j, param)
  separator = i
  (i..j).each do |k|
    if array[k][param] > array[separator][param]
      separator = k
      break
    elsif array[k][param] < array[separator][param]
      break
    else
      separator = k
    end
  end
  return separator
end

def part_of_quick_sort(array, i, j, param)
  if i >= j
    return
  end
  separator = take_separator(array, i, j, param)
  if separator == j
    return
  end
  left = separator
  right = j
  separator = array[separator][param]
  while left < right
    swap(array, left, right)
    while array[left][param] < separator
      left += 1
    end
    while array[right][param] >= separator
      right -= 1
    end
  end
  part_of_quick_sort(array, i, left - 1, param)
  part_of_quick_sort(array, left, j, param)
end

def quick_sort(array, param)
  part_of_quick_sort(array, 0, array.size - 1, param)
end

def bin_search_area(elem, array, i, j, param)
  if i < j
    n = i + (j - i) / 2
    if array[n][param] < elem[0]
      bin_search_area(elem, array, n + 1, j, param)
    elsif array[n][param] >= elem[0]
      bin_search_area(elem, array, i, n, param)
    end
  else
    if array[i][param] >= elem[0]
      return [i, bin_search_area_max(elem[1], array, i, array.size - 1, param)]
    else
      return nil
    end
  end
end

def bin_search_area_max(elem, array, i, j, param)
  if i < j
    n = i + (j - i) / 2 + 1
    if array[n][param] <= elem
      bin_search_area_max(elem, array, n, j, param)
    elsif array[n][param] > elem
      bin_search_area_max(elem, array, i, n - 1, param)
    end
  else
    if array[j][param] <= elem
      return j
    else
      return nil
    end
  end
end

def bin_search_array(elem_array, array, param)
  new_array = []
  if elem_array.size == 1
    new_array = bin_search_area(elem_array + elem_array, array, 0, array.size - 1, param)
  else
    new_array = bin_search_area(elem_array, array, 0, array.size - 1, param)
  end
  return new_array
end

def sort_by_param(param, array)
  quick_sort(array, param)
end

class Persons_array
  attr_accessor :array
  attr_reader :id, :names
  
  def initialize
    @names = []
    @array = []
    @id = 0
  end
  
  def add_person(name, age, salary, height, weight)
    @array[@id] = [@id, age, salary, height, weight]
    @names[@id] = name
    @id += 1
  end
  
  def person_bin_search(elem, param_str, array)
    case param_str
    when 'age'
      param = 1
    when 'salary'
      param = 2
    when 'height'
      param = 3
    when 'weight'
      param = 4
    end
    sort_by_param(param, array)
    n = bin_search_array(elem, array, param)
    if n.nil?
      return nil
    else
      new_array = []
      (n[0]..n[1]).each{|k| new_array.push(array[k])}
      return new_array
    end
  end
  
  def person_search(hash)
    array = @array
    hash.keys.each do |k|
      array = person_bin_search(hash[k], k, array)
      if array.nil?
        break
      end
    end
    if array.nil?
      return nil
    else
      array.each{|k| k[0] = @names[k[0]]}
      return array
    end
  end
end

def random_persons(n)
  persons = Persons_array.new
  n.times do |k|
    persons.add_person('name' + k.to_s, rand(0..100), rand(0..1000000), rand(0..200), rand(0..200))
  end
  return persons
end

persons = random_persons(10000000)
puts 'persons created'
t1 = Time.now
selectid_persons = persons.person_search({'age' => [20, 30], 'salary' => [20000, 30000], 'height' => [180, 185]})
t2 = Time.now
if selectid_persons.nil?
  puts 'Person not found'
else
  selectid_persons.each{|k| puts k.inspect}
end
puts 'select time: ' + (t2 - t1).to_s