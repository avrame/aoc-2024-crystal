enum Bearing : UInt8
  North
  East
  South
  West
end

input_filename = ARGV[0]

map = [] of Array(Char)

File.each_line(input_filename) do |line|
  map << line.chars
end

guard = Guard.new(map)
guard.patrol

class Guard
  @row : Int32
  @col : Int32
  @bearing : Bearing = Bearing::North

  def initialize(@map : Array(Array(Char)))
    @row, @col = find_guard_pos
    set_pos_visited
  end

  def patrol
    case @bearing
    when .north?
      check(@row - 1, @col)
    when .east?
      check(@row, @col + 1)
    when .south?
      check(@row + 1, @col)
    when .west?
      check(@row, @col - 1)
    end
  end

  private def check(row, col)
    if row == 120
      puts col
    end
    if row < 0 || row == @map.size || col < 0 || col == @map[0].size
      end_patrol
      return
    end
    case @map[row][col]
    when '#'
      turn_right
      patrol
    else
      @row, @col = row, col
      set_pos_visited
      patrol
    end
  end

  private def end_patrol
    unique_pos_count = 0
    @map.each do |row|
      row.each do |space|
        if space == 'X'
          unique_pos_count += 1
        end
      end
    end
    # save_map
    puts "unique_pos_count = #{unique_pos_count + 1}" # Add 1 for starting position
  end

  private def set_pos_visited
    @map[@row][@col] = 'X' if @map[@row][@col] != '^'
  end

  private def turn_right
    if @bearing == Bearing::West
      @bearing = Bearing::North
    else
      @bearing += 1
    end
  end

  private def find_guard_pos
    @map.each_with_index do |row, row_idx|
      row.each_with_index do |space, col_idx|
        if space == '^'
          return row_idx, col_idx
        end
      end
    end
    raise Exception.new "Guard not in map!"
  end

  private def save_map
    map_str = String.build do |str|
      @map.each do |row|
        str << row.join("")
        str << "\n"
      end
    end
    File.write("map.txt", map_str)
  end
end
