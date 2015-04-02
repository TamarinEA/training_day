N = gets.chomp.split(".")
new_N = N.each.with_index.inject(0){|result,(j, i)| result + (j.to_i) * (256**(N.size - i - 1))}

File.open('IpToCountry.csv').each do |line|
  if line[0] != "#"
    s = line.split(",")
	if new_N<=s[1][1..-2].to_i && new_N>=s[0][1..-2].to_i
	  puts s[4][1..-2]
	  break
	end
  end
end