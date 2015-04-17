def bin_search(elem, array, i, j)
  if i < j
    n = i + (j - i) / 2
    if array[n] < elem
      bin_search(elem, array, n + 1, j)
    elsif array[n] > elem
      bin_search(elem, array, i, n - 1)
    else
      return n
    end
  elsif array[j] == elem
    return j
  else
    return nil
  end
end

def bin_search_area(elem, array, i, j)
  if i < j
    n = i + (j - i) / 2
    if array[n] < elem[0]
      bin_search_area(elem, array, n + 1, j)
    elsif array[n] >= elem[0]
      bin_search_area(elem, array, i, n)
    end
  else
    if array[i] >= elem[0]
      return [i, bin_search_area_max(elem[1], array, i, array.size - 1)]
    else
      return nil
    end
  end
end

def bin_search_area_max(elem, array, i, j)
  if i < j
    n = i + (j - i) / 2 + 1
    if array[n] <= elem
      bin_search_area_max(elem, array, n, j)
    elsif array[n] > elem
      bin_search_area_max(elem, array, i, n - 1)
    end
  else
    if array[j] <= elem
      return j
    else
      return nil
    end
  end
end

def bin_search_array(elem_array, array)
  new_array = []
  if elem_array.size == 1
    new_array = bin_search_area(elem_array + elem_array, array, 0, array.size - 1)
  else
    new_array = bin_search_area(elem_array, array, 0, array.size - 1)
  end
  return new_array
end

a = [0,1,2,3,3,3,4,5,6,7,7,7,8,8,9]
puts a.size - 1
puts bin_search_array([7], a)