#!/usr/local/bin/ruby

require 'erb'

files = Dir.new('.').entries

files.each do |file|
  if file.match(/\.markdown$/)
    html_file = file.sub(/\.markdown/, '.html')
    `Markdown.pl #{file} > #{html_file}`
    inner_html = File.open(html_file) {|file| file.read()}
    output_file = File.new(html_file, 'w')
    layout = File.new('layout.erb', 'r').read()
    eruby = ERB.new(layout)
    output_file.print eruby.result(binding())
    output_file.close
  end
end
