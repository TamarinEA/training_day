puts "Enter your number"
N = gets.chomp.to_s.split("")
hash_top = {"0"=>" _ ", "1"=>"   ", "2"=>" _ ", "3"=>" _ ", "4"=>"   ", "5"=>" _ ", "6"=>" _ ", "7"=>" _ ", "8"=>" _ ", "9"=>" _ "}
hash_mid = {"0"=>"| |", "1"=>"  |", "2"=>" _|", "3"=>" _|", "4"=>"|_|", "5"=>"|_ ", "6"=>"|_ ", "7"=>"  |", "8"=>"|_|", "9"=>"|_|"}
hash_bot = {"0"=>"|_|", "1"=>"  |", "2"=>"|_ ", "3"=>" _|", "4"=>"  |", "5"=>" _|", "6"=>"|_|", "7"=>"  |", "8"=>"|_|", "9"=>" _|"}
lcd = [N.map{|s| hash_top[s]} * "", N.map{|s| hash_mid[s]} * "", N.map{|s| hash_bot[s]} * ""]
puts lcd