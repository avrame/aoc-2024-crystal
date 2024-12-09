enum Bearing : UInt8
  North
  East
  South
  West
end

map = [] of Array(Char)

File.each_line("input.txt") do |line|
  map << line.chars
end

guard = Guard.new(map)
guard.patrol
puts guard.obstructions

class Guard
  @row : Int32
  @col : Int32
  @bearing : Bearing = Bearing::North

  @checking_for_loop = false
  @prev_turns : Set(Tuple(Bearing, Int32, Int32))
  property obstructions = 0

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
    if is_in_infinite_loop
      return true
    end

    if left_map(row, col)
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
      if !@checking_for_loop && loops_forever
        @obstructions += 1
      end
      @row, @col = row, col
      set_pos_visited
      patrol
    end
  end

  private def is_in_infinite_loop
    @checking_for_loop && @prev_turns.includes?({@bearing, @row, @col})
  end

  private def left_map(row, col)
    row < 0 || row == @map.size || col < 0 || col == @map[0].size
  end

  private def loops_forever
    loop_check_guard = Guard.new(@map, @bearing, @row, @col)
    loop_check_guard.patrol
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
end
