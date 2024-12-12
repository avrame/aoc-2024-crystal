DIRS = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
input_filename = ARGV[0]

garden = [] of Array(Char)
File.each_line(input_filename) do |line|
  garden << line.chars
end

total_price = 0
mapped_plots = Set(Tuple(Int32, Int32)).new

garden.each_with_index do |row, r_idx|
  row.each_with_index do |plant_type, c_idx|
    area, perimeter = map_region(garden, mapped_plots, plant_type, r_idx, c_idx)
    total_price += area * perimeter
  end
end

puts total_price

def map_region(garden, mapped_plots, plant_type, r_idx, c_idx)
  if mapped_plots.includes?({r_idx, c_idx})
    return 0, 0
  end
  mapped_plots << {r_idx, c_idx}

  total_area = 1
  total_perimeter = 0

  DIRS.each do |dir|
    check_row_idx = r_idx + dir[0]
    check_col_idx = c_idx + dir[1]
    if on_map(garden, check_row_idx, check_col_idx) && garden[check_row_idx][check_col_idx] == plant_type
      area, perimeter = map_region(garden, mapped_plots, plant_type, check_row_idx, check_col_idx)
      total_area += area
      total_perimeter += perimeter
    else
      total_perimeter += 1
    end
  end

  return total_area, total_perimeter
end

def on_map(garden, row_idx, col_idx)
  row_idx >= 0 && row_idx < garden.size && col_idx >= 0 && col_idx < garden[0].size
end

def print_garden(garden)
  garden_str = String.build do |str|
    garden.each do |row|
      str << row.join("")
      str << "\n"
    end
  end
  puts garden_str
end
