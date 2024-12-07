NEEDLE = "MAS"
haystack = [] of Array(Char)

File.each_line("input.txt") do |line|
  haystack << line.chars
end

xmas_count = 0
row = col = 0
until row == haystack.size
  until col == haystack[0].size
    xmas_count += find_xmas(haystack, row, col)
    col += 1
  end
  row += 1
  col = 0
end

puts "xmas_count = #{xmas_count}"

def find_xmas(haystack, row, col)
  if haystack[row][col] != 'A' || row == 0 || col == 0 || row == haystack.size - 1 || col == haystack[row].size - 1
    return 0
  end
  
  if haystack[row - 1][col - 1] == 'M' && haystack[row + 1][col + 1] == 'S' || haystack[row - 1][col - 1] == 'S' && haystack[row + 1][col + 1] == 'M'
    if haystack[row + 1][col - 1] == 'M' && haystack[row - 1][col + 1] == 'S' || haystack[row + 1][col - 1] == 'S' && haystack[row - 1][col + 1] == 'M'
      return 1
    end
  end

  return 0
end