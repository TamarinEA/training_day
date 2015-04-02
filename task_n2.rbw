center_point = [1.0, 1.0]                                           # исходная точка
radius = 3.5                                                        # радиус
puts "Center point: " + center_point.inspect + ". Radius: " + radius.to_s
puts "Enter the array of points"
several_points = eval(gets.chomp)   # входные данные

several_points.map!{|x| ((((x[0] - center_point[0])**2 + (x[1] - center_point[1])**2)**0.5) < radius ? x : nil)}.compact!
puts "The circle includes the points: " + several_points.inspect