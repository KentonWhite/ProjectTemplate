#!/usr/bin/ruby

require 'set'

lines = `cat /usr/share/dict/words`
lines = lines.split(/\n/)

lines = lines.map {|line| line.downcase}
lines = Set.new(lines).to_a

output_file = File.new('letters.csv', 'w')

output_file.puts ['Word', 'FirstLetter', 'SecondLetter'].join(',')

lines.each do |line|
  output_file.puts [line, line[0], line[1]].join(',')
end

output_file.close

`bzip2 letters.csv`
