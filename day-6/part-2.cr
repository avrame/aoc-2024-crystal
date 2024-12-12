enum Bearing : UInt8
  North
  East
  South
  West
end

map = [] of Array(Char)
input_filename = ARGV[0]

File.each_line(input_filename) do |line|
  map << line.chars
end

guard = Guard.new(map)
guard.patrol
guard.save_map
puts guard.obstructions.size

class Guard
  @row : Int32
  @col : Int32
  @bearing : Bearing = Bearing::North

  @checking_for_loop = false
  @prev_turns : Set(Tuple(Bearing, Int32, Int32))
  property obstructions = Set(Tuple(Int32, Int32)).new

  def initialize(@map : Array(Array(Char)))
    @row, @col = find_guard_pos
    @prev_turns = Set(Tuple(Bearing, Int32, Int32)).new
    set_pos_visited
  end

  def initialize(@map : Array(Array(Char)), @bearing, @row, @col)
    @checking_for_loop = true
    @prev_turns = Set.new [{@bearing, @row, @col}]
    turn_right
  end

  def patrol
    case @bearing
    when .north?
      return check(@row - 1, @col)
    when .east?
      return check(@row, @col + 1)
    when .south?
      return check(@row + 1, @col)
    when .west?
      return check(@row, @col - 1)
    end
  end

  private def check(row, col)
    if in_a_loop?
      return true
    end

    if left_map?(row, col)
      return false
    end

    case @map[row][col]
    when '#'
      if @checking_for_loop
        @prev_turns << {@bearing, @row, @col}
      end
      turn_right
      patrol
    else
      if !@checking_for_loop && obstruction_causes_loop?
        @obstructions << {@row, @col}
        case @bearing
        when .north?
          @map[@row - 1][@col] = 'O'
        when .east?
          @map[@row][@col + 1] = 'O'
        when .south?
          @map[@row + 1][@col] = 'O'
        when .west?
          @map[@row][@col - 1] = 'O'
        end
      end
      @row, @col = row, col
      # set_pos_visited
      patrol
    end
  end

  private def in_a_loop?
    @checking_for_loop && @prev_turns.includes?({@bearing, @row, @col})
  end

  private def left_map?(row, col)
    row < 0 || row == @map.size || col < 0 || col == @map[0].size
  end

  private def obstruction_causes_loop?
    loop_check_guard = Guard.new(@map, @bearing, @row, @col)
    loop_check_guard.patrol
  end

  private def set_pos_visited
    @map[@row][@col] = 'X' if @map[@row][@col] != '^' && @map[@row][@col] != 'O'
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

  def save_map
    map_str = String.build do |str|
      @map.each do |row|
        str << row.join("")
        str << "\n"
      end
    end
    File.write("map.txt", map_str)
  end
end
