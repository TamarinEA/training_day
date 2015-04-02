a = [[4, 19], nil, [32, 41], 0, 0, 0, 65]
b = [234, 0, nil, [19], 21, [41, 41, 54]]

a = a.flatten.compact
b = b.flatten.compact

c = Hash.new(0)                            # ключи хэша - элементы
(a&b).map{|x| c[x] = 0}                    # из пересечения 
(a+b).map{|x| c[x]+=1 if c.key?(x)}        # массивово a и b

#c = (a+b).inject(Hash.new{0}){|result, x|   # ключи хэша - элементы
#                              result[x]+=1  # из объединения
#                              result        # массивово a и b
#                             }
puts c