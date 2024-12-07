# Advent of Code 2024: Day 2 - Part 2

safe_reports = 0

File.each_line("input.txt") do |line|
  report = line.split(" ").map(&.to_i)
  report_test = report.dup
  remove_idx = -1
  report_is_safe = true
  until report_safe?(report_test)
    remove_idx += 1
    if remove_idx == report.size
      report_is_safe = false
      break
    end
    report_test = report.dup
    report_test.delete_at(remove_idx)
  end
  safe_reports += 1 if report_is_safe
end

puts safe_reports

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