module Part1
  extend self

  map = [] of Array(Char)
  alias Frequency = Char
  alias Location = NamedTuple(row_idx: Int32, col_idx: Int32)
  locations = Hash(Frequency, Array(Location)).new
  an_locations = Set(Location).new
  antinodes_count = 0

  File.each_line("input.txt") do |line|
    map << line.chars
  end

  map.each_index do |row_idx|
    map[row_idx].each_index do |col_idx|
      c = map[row_idx][col_idx]
      if c != '.'
        antinodes_count += 1
        if !locations.has_key?(c)
          locations[c] = [] of Location
        end
        locations[c] << {row_idx: row_idx, col_idx: col_idx}
      end
    end
  end

  # puts locations

  locations.each_value do |freq_locs|
    freq_locs.each_index do |idx|
      loc = freq_locs[idx]
      rest_locs = freq_locs[idx + 1..]
      rest_locs.each do |other_loc|
        antinodes_count += count_antinodes(map, loc, other_loc, an_locations)
      end
    end
  end

  puts "antinodes_count = #{antinodes_count}"
  print_map(map)

  def count_antinodes(map, loc, other_loc, an_locations)
    count = 0

    multiplier = 1
    count_back = true
    count_forward = true
    while count_back || count_forward
      an_1_loc = {
        row_idx: loc[:row_idx] + multiplier * (loc[:row_idx] - other_loc[:row_idx]),
        col_idx: loc[:col_idx] + multiplier * (loc[:col_idx] - other_loc[:col_idx]),
      }
      an_2_loc = {
        row_idx: other_loc[:row_idx] + multiplier * (other_loc[:row_idx] - loc[:row_idx]),
        col_idx: other_loc[:col_idx] + multiplier * (other_loc[:col_idx] - loc[:col_idx]),
      }

      if count_back && an_on_map(an_1_loc, map)
        if !an_locations.includes?(an_1_loc) && map[an_1_loc[:row_idx]][an_1_loc[:col_idx]] == '.'
          count += 1
          map[an_1_loc[:row_idx]][an_1_loc[:col_idx]] = '#'
          an_locations << an_1_loc
        end
      else
        count_back = false
      end

      if count_forward && an_on_map(an_2_loc, map)
        if !an_locations.includes?(an_2_loc) && map[an_2_loc[:row_idx]][an_2_loc[:col_idx]] == '.'
          count += 1
          map[an_2_loc[:row_idx]][an_2_loc[:col_idx]] = '#'
          an_locations << an_2_loc
        end
      else
        count_forward = false
      end

      multiplier += 1
    end

    count
  end

  def an_on_map(an, map)
    an[:row_idx] >= 0 && an[:col_idx] >= 0 && an[:row_idx] < map.size && an[:col_idx] < map[0].size
  end

  def print_map(map)
    map_str = String.build do |str|
      map.each do |row|
        str << row.join("")
        str << "\n"
      end
    end
    File.write("map.txt", map_str)
  end
end
