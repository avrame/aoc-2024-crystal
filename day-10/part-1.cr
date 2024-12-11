map = [] of Array(Int8)
trail_count = 0
File.each_line("input.txt") do |line|
    map << line.chars.map {|char| char.to_i8}
end

map.each_with_index do |row, row_idx|
    row.each_with_index do |pos, col_idx|
        trail_count += count_trails(map, row_idx, col_idx, 0, Set(Tuple(Int32, Int32)).new)
    end
end

puts "trail_count = #{trail_count}"

def count_trails(map, row_idx, col_idx, height, trail_ends)
    count = 0
    dirs = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    if map[row_idx][col_idx] == height
        # puts "map[#{row_idx}][#{col_idx}] == #{height}"
        if height == 9
            if !trail_ends.includes?({row_idx, col_idx})
                trail_ends << {row_idx, col_idx}
                return 1
            end
            return 0
        end
        dirs.each do |dir|
            test_row_idx = row_idx + dir[0]
            test_col_idx = col_idx + dir[1]
            if test_row_idx >= 0 && test_row_idx < map.size && test_col_idx >=0 && test_col_idx < map[0].size
                count += count_trails(map, test_row_idx, test_col_idx, height + 1, trail_ends)
            end
        end
    end
    count
end

