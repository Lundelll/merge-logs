
def read_line_from_file(file)
  file.readline
rescue EOFError
  nil
end

begin
  match_date_regexp = /^[0-9]{4}-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])\s[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}/
  input_file_1 = File.open('file1.log', 'r')
  input_file_2 = File.open('file2.log', 'r')

  File.open('output.log', 'w') do |of|
    left = read_line_from_file(input_file_1)
    right = read_line_from_file(input_file_2)

    until left.nil? && right.nil?

      if left.nil? || right.nil?
        if left.nil?
          of << right
          right = read_line_from_file(input_file_2)
          next
        elsif right.nil?
          of << left
          left = read_line_from_file(input_file_1)
          next
        end
      elsif left =~ match_date_regexp && right =~ match_date_regexp
        if left < right
          of << left
          left = read_line_from_file(input_file_1)
          next
        else
          of << right
          right = read_line_from_file(input_file_2)
          next
        end
      elsif left =~ match_date_regexp
        of << right
        right = read_line_from_file(input_file_2)
        next
      elsif right =~ match_date_regexp
        of << left
        left = read_line_from_file(input_file_1)
        next
      end
    end
  end
ensure
  input_file_1.close
  input_file_2.close
end

