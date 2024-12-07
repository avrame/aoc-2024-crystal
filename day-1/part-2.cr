# Advent of Code 2024: Day 1 - Part 2

col_1 = [] of Int32
col_2 = [] of Int32

File.each_line("input") do |line|
  nums = line.split("   ")
  col_1 << nums[0].to_i
  col_2 << nums[1].to_i
end

similarity_score = col_1.map do |num|
  col_2.select { |i| i == num }.sum
end.sum

puts similarity_score
  