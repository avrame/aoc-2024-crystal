mangled_code = File.read("input.txt")
# puts mangled_code
matches = mangled_code.scan(/mul\((\d+),(\d+)\)/)

sum = matches.map do |match_data|
  match_data[1].to_i * match_data[2].to_i
end.sum

puts sum
