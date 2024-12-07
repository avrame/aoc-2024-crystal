dirs = [
  {x: 0, y: 1},
  {x: 0, y: -1},
  {x: 1, y: 0},
  {x: 1, y: 1},
  {x: 1, y: -1},
  {x: -1, y: 0},
  {x: -1, y: 1},
  {x: -1, y: -1},
]

haystack = [] of Array(Char)

File.each_line("input.txt") do |line|
  haystack << line.chars
end

xmas_count = 0
row = col = 0
until row == haystack.size
  until col == haystack[0].size
    dirs.each do |dir|
      xmas_count += count_xmas(haystack, dir, row, col)
    end
    col += 1
  end
  row += 1
  col = 0
end

puts "xmas_count = #{xmas_count}"

def count_xmas(haystack, dir, row, col)
  needle = "XMAS"
  x = col
  y = row
  needle.each_char do |ch|
    if x < 0 || y < 0 || haystack[y]?.nil? || haystack[y][x]?.nil? || ch != haystack[y][x]
      return 0
    end
    x += dir[:x]
    y += dir[:y]
  end
  puts "XMAS found at (#{row},#{col}) to (#{y},#{x})"
  return 1
end