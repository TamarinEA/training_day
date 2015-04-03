center_point = [1.0, 1.0]                                           # исходная точка
circle_radius = 3.0                                                        # радиус
puts "Center point: " + center_point.inspect + ". Radius: " + circle_radius.to_s
several_points = [[1,0],[1,1],[1,2],[1,3],[1,4],[2,2],[3,1]]
puts "Array of some points" +several_points.inspect

def points_in_circle(center, radius, points_array)
  several_points_in_circle = Array.new
  points_array.each do |point|
    if (((point[0] - center[0])**2 + (point[1] - center[1])**2)**0.5) < radius
      several_points_in_circle << point
    end
  end
  return several_points_in_circle
end

puts "The circle includes the points: " + points_in_circle(center_point, circle_radius, several_points).inspect