enum Bearing : UInt8
  North
  East
  South
  West
end

input_filename = ARGV[0]

init_map = Map.new input_filename
start_row_idx, start_col_idx = init_map.find_guard_start_pos
map_with_path = init_map.clone
path_guard = Guard.new(map_with_path, start_row_idx, start_col_idx)
path_guard.patrol # create initial path

marked_up_map = map_with_path.clone
obstacles_count = 0
map_with_path.each_with_index do |row, row_idx|
  row.each_with_index do |space, col_idx|
    if space == 'X'
      test_map = map_with_path.clone
      guard = Guard.new(test_map, start_row_idx, start_col_idx)
      test_map.set_test_obstacle(row_idx, col_idx)
      if guard.will_loop_forever?
        obstacles_count += 1
        marked_up_map[row_idx][col_idx] = 'O'
      else
        marked_up_map[row_idx][col_idx] = 'X'
      end
    end
  end
end
marked_up_map.save_to_file
puts "obstacles_count = #{obstacles_count}"

class Map
  @map = [] of Array(Char)

  def initialize(input_filename : String)
    File.each_line(input_filename) do |line|
      @map << line.chars
    end
  end

  def initialize(@map : Array(Array(Char)))
  end

  def [](row_idx)
    @map[row_idx]
  end

  def []?(row_idx)
    @map[row_idx]?
  end

  def []=(row_idx, row)
    @map[row_idx] = row
  end

  def size
    @map.size
  end

  def each_with_index(&)
    @map.each_with_index do |row, idx|
      yield row, idx
    end
  end

  def clone
    cloned_map = @map.map do |row|
      row.clone
    end
    Map.new cloned_map
  end

  def find_guard_start_pos
    @map.each_with_index do |row, row_idx|
      row.each_with_index do |space, col_idx|
        if space == '^'
          return row_idx, col_idx
        end
      end
    end
    raise Exception.new "Guard not in map!"
  end

  def set_test_obstacle(row, col)
    @map[row][col] = '#'
  end

  def print
    puts generate_map_str
    puts "\n"
  end

  def save_to_file
    File.write("map.txt", generate_map_str)
  end

  private def generate_map_str
    String.build do |str|
      @map.each do |row|
        str << row.join("")
        str << "\n"
      end
    end
  end
end

class Guard
  @map : Map
  @row : Int32
  @col : Int32
  @bearing : Bearing = Bearing::North
  @prev_turns : Set(Tuple(Bearing, Int32, Int32)) | Nil

  def initialize(@map : Map, @row, @col)
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

  def will_loop_forever?
    @prev_turns = Set(Tuple(Bearing, Int32, Int32)).new
    return patrol
  end

  private def check(row, col)
    if row < 0 || row == @map.size || col < 0 || col == @map[0].size
      return false
    end
    case @map[row][col]
    when '#'
      prev_turns = @prev_turns
      if prev_turns
        if prev_turns.includes?({@bearing, @row, @col})
          return true
        end
        prev_turns << {@bearing, @row, @col}
      end
      turn_right
      patrol
    else
      @row, @col = row, col
      set_pos_visited
      patrol
    end
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
end
