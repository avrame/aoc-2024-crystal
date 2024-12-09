module Part1
  final_sum = 0.to_u128

  File.each_line("input-test.txt") do |line|
    test_val, nums = get_test_val_and_nums(line)
    # puts "#{test_val}: #{nums}"
    if do_op(test_val, nums, 0, '+', 0)
      final_sum += test_val
    end
  end

  puts "final_sum = #{final_sum}"

  def self.get_test_val_and_nums(line) : Tuple(UInt128, Array(UInt128))
    test_val_and_nums = line.split(':')
    test_val = test_val_and_nums[0].to_u128
    str_nums = test_val_and_nums[1].split(' ')
    nums = str_nums.map do |str_num|
      str_num.to_u128?
    end.compact
    {test_val, nums}
  end

  def self.do_op(test_val, nums, idx, op, total : UInt128)
    if idx == nums.size
      if test_val == total
        return true
      end
      return false
    end

    case op
    when '+'
      new_total = total + nums[idx]
    when '*'
      new_total = total * nums[idx]
    when '|'
      new_total = "#{total}#{nums[idx]}".to_u128
    end

    if new_total.not_nil! > test_val
      return false
    end

    return do_op(test_val, nums, idx + 1, '+', new_total.not_nil!) || do_op(test_val, nums, idx + 1, '*', new_total.not_nil!) || do_op(test_val, nums, idx + 1, '|', new_total.not_nil!)
  end
end
