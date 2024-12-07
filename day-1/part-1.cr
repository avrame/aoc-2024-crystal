# Advent of Code 2024: Day 1 - Part 1

col_1 = [] of Int32
col_2 = [] of Int32
diffs = [] of Int32

File.each_line("input") do |line|
  nums = line.split("   ")
  col_1 << nums[0].to_i
  col_2 << nums[1].to_i
end

col_1.sort!
col_2.sort!

col_1.each_with_index do |num, i|
  diffs << (num - col_2[i]).abs
end

puts diffs.sum
