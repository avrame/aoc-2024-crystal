# Advent of Code 2024: Day 2 - Part 1

safe_reports = 0

File.each_line("input.txt") do |line|
  report = line.split(" ").map(&.to_i)
  safe_reports += 1 if report_safe?(report)
end

def report_safe?(report)
  ascending = report[0] - report[-1] < 0
  level_idx = 0
  while level_idx < report.size - 1
    level = report[level_idx]
    next_level = report[level_idx + 1]
    diff = next_level - level
    if diff == 0 || ascending && diff < 0 || !ascending && diff > 0 || diff.abs > 3
      return false
    end
    level_idx += 1
  end
  return true
end

puts safe_reports