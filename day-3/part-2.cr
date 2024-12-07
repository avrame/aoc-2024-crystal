mangled_code = File.read("input.txt")
matches = mangled_code.scan(/(?:mul\((\d+),(\d+)\)|do(n't)?\(\))/)

instructions_enabled = true
mult_results = [] of Int32
matches.each do |match_data|
  puts match_data[0]
  case match_data[0]
  when "do()"
    instructions_enabled = true
  when "don't()"
    instructions_enabled = false
  else
    if instructions_enabled
      mult_results << match_data[1].to_i * match_data[2].to_i
    end
  end
end

puts mult_results.sum
