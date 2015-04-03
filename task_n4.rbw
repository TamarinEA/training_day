puts "Enter your number"
some_number = gets.chomp.to_s.split("")
first_string_hash = {"0"=>" _ ", "1"=>"   ", "2"=>" _ ", "3"=>" _ ", "4"=>"   ", "5"=>" _ ", "6"=>" _ ", "7"=>" _ ", "8"=>" _ ", "9"=>" _ "}
second_string_hash = {"0"=>"| |", "1"=>"  |", "2"=>" _|", "3"=>" _|", "4"=>"|_|", "5"=>"|_ ", "6"=>"|_ ", "7"=>"  |", "8"=>"|_|", "9"=>"|_|"}
third_string_hash = {"0"=>"|_|", "1"=>"  |", "2"=>"|_ ", "3"=>" _|", "4"=>"  |", "5"=>" _|", "6"=>"|_|", "7"=>"  |", "8"=>"|_|", "9"=>" _|"}
convert_to_lcd = 
  [some_number.map{|s| first_string_hash[s]} * "", 
   some_number.map{|s| second_string_hash[s]} * "", 
   some_number.map{|s| third_string_hash[s]} * ""]
puts convert_to_lcd