center_point = [1.0, 1.0]
circle_radius = 3.0
puts "Center point: " + center_point.inspect + ". Radius: " + circle_radius.to_s
several_points = [[1,0],[1,1],[1,2],[1,3],[1,4],[2,2],[3,1]]
puts "Array of some points" +several_points.inspect

def points_in_circle(center, radius, points_array)
  several_points_in_circle = points_array.select{ |point|
    (((point[0] - center[0])**2 + (point[1] - center[1])**2)**0.5) < radius}
  return several_points_in_circle
end

puts "The circle includes the points: " + points_in_circle(center_point, circle_radius, several_points).inspect