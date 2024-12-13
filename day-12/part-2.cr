enum Direction
  Up
  Right
  Down
  Left
end
DIRS = [{row: -1, col: 0}, {row: 0, col: 1}, {row: 1, col: 0}, {row: 0, col: -1}]
input_filename = ARGV[0]

garden = [] of Array(Char)
File.each_line(input_filename) do |line|
  garden << line.chars
end

total_price = 0
mapped_plots = Set(NamedTuple(row: Int32, col: Int32)).new

garden.each_with_index do |row, r_idx|
  row.each_with_index do |plant_type, c_idx|
    plot_sides = Set(NamedTuple(row: Int32, col: Int32, dir: Direction)).new
    area = map_region(garden, plant_type, r_idx, c_idx, mapped_plots, plot_sides)
    total_price += area * count_region_sides(plot_sides)
  end
end

def count_region_sides(plot_sides)
  return 0 if plot_sides.size == 0
  region_sides = 0
  Direction.each do |dir|
    sides_of_dir = plot_sides.select { |ps| ps[:dir] == dir }
    if dir == Direction::Up || dir == Direction::Down
      grouped_sides = sides_of_dir.group_by { |ps| ps[:row] }
    else
      grouped_sides = sides_of_dir.group_by { |ps| ps[:col] }
    end
    grouped_sides_sorted = grouped_sides.map do |gs|
      gs[1].sort_by { |s| dir == Direction::Up || dir == Direction::Down ? s[:col] : s[:row] }
    end
    grouped_sides_sorted.each do |gs|
      row_or_col = dir == Direction::Up || dir == Direction::Down ? "col" : "row"
      gs.each_index do |idx|
        if idx < gs.size - 1
          if gs[idx][row_or_col] + 1 != gs[idx + 1][row_or_col]
            region_sides += 1
          end
        else
          region_sides += 1
        end
      end
    end
  end
  region_sides
end

puts "total_price = #{total_price}"

def map_region(garden, plant_type, r_idx, c_idx, mapped_plots, plot_sides)
  if mapped_plots.includes?({row: r_idx, col: c_idx})
    return 0
  end
  mapped_plots << {row: r_idx, col: c_idx}

  total_area = 1

  Direction.each do |dir_enum|
    dir = DIRS[dir_enum.value]
    check_row_idx = r_idx + dir[:row]
    check_col_idx = c_idx + dir[:col]
    if on_map(garden, check_row_idx, check_col_idx) && garden[check_row_idx][check_col_idx] == plant_type
      area = map_region(garden, plant_type, check_row_idx, check_col_idx, mapped_plots, plot_sides)
      total_area += area
    else
      plot_sides << {row: r_idx, col: c_idx, dir: dir_enum}
    end
  end

  return total_area
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
