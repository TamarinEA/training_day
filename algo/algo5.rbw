require 'benchmark'

# quick sort для сортировки по одному из параметров
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

# бинарный поиск элементов (с повторениями), принадлежащих отрезку [a, b] 
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
  if elem_array.size == 1
    return bin_search_area(elem_array + elem_array, array, 0, array.size - 1, param)
  else
    return bin_search_area(elem_array, array, 0, array.size - 1, param)
  end
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
  
  # ищем по одному из параметров
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
    t1 = Time.now
    array.sort_by!{|a| a[param]}
    #quick_sort(array, param)
    t2 = Time.now
    n = bin_search_array(elem, array, param)
    t3 = Time.now
    puts 'quick sort ' + param_str + ' time: ' + (t2 - t1).to_s
    puts 'my bin search ' + param_str + ' time: ' + (t3 - t2).to_s
    if n.nil? || n[1].nil?
      return nil
    else
      new_array = []
      (n[0]..n[1]).each{|k| new_array.push(array[k])}
      return new_array
    end
  end
  
  # разбираем входные данные
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

# 10млн персон...
def random_persons(n)
  persons = Persons_array.new
  n.times do |k|
    persons.add_person('name' + k.to_s, rand(0..100), rand(0..1000000.0).round(1), rand(0..200), rand(0..200))
  end
  return persons
end

def seriatim_persons(n)
  persons = Persons_array.new
  n.times do |k|
    persons.add_person('name' + k.to_s, k % 101, k, k % 201, k % 201)
  end
  return persons
end

# для поиска по одному значению [a]
select_hash = {'age' => [22, 25], 'salary' => [20000.0, 25000.0], 'height' => [180, 200], 'weight' => [50, 100]}
puts select_hash
persons = random_persons(10000000)
puts 'Persons array created.'
t1 = Time.now
selected_persons = persons.person_search(select_hash)
t2 = Time.now
puts 'All time: ' + (t2 - t1).to_s
if selected_persons.nil?
  puts 'Person not found'
else
  puts selected_persons.inspect
end