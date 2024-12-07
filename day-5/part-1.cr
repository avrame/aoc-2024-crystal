ordering_rules = {} of String => Array(String)
updates = [] of Array(String)

parse_input("input.txt", ordering_rules, updates)

# puts "ordering_rules = #{ordering_rules}"
# puts "updates = #{updates}"

mid_pages_sum = updates.map do |update|
  check_update(update, ordering_rules)
end.sum

puts "mid_pages_sum = #{mid_pages_sum}"

def parse_input(file, ordering_rules, updates)
  parse_updates = false
  File.each_line(file) do |line|
    if line != ""
      if !parse_updates
        ord_pgs = line.split("|")
        first_pg = ord_pgs[0]
        if !ordering_rules.has_key?(first_pg)
          ordering_rules[first_pg] = [] of String
        end
        ordering_rules[first_pg] << ord_pgs[1]
      else
        updates << line.split(",")
      end
    else
      parse_updates = true
    end
  end
end

def check_update(update, ordering_rules)
  update[..-2].each_with_index do |page, idx|
    update[idx+1..].each do |following_page|
      if !ordering_rules.has_key?(page) || !ordering_rules[page].includes?(following_page)
        return 0
      end
    end
  end
  mid_idx = (update.size / 2).floor.to_i32
  middle_page = update[mid_idx].to_i8
  return middle_page
end