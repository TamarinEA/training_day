puts "Enter IP"
ip_number = gets.chomp.split(".")
encoded_ip_number = ip_number.each.with_index.inject(0){|result,(j, i)| result + (j.to_i) * (256**(ip_number.size - i - 1))}

File.open('IpToCountry.csv').each do |line|
  if line[0] != "#"
    country_ip_line = line.split(",")
    if encoded_ip_number <= country_ip_line[1][1..-2].to_i && encoded_ip_number >= country_ip_line[0][1..-2].to_i
      puts country_ip_line[4][1..-2]
      break
    end
  end
end