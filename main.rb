#!/usr/bin/ruby -w

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'

PROTOCOL = 'http'
DOMAIN = 'www.tutorialspoint.com'

# remote is too slow, try to implement later for local copy
links = Nokogiri::HTML(open(PROTOCOL << '://' << DOMAIN << '/cplusplus/index.htm')).css('div#leftcol > ul.menu > li > a')

# Filter out anything that is not course material
links = links.select { |link| link if link['href'].include?('cplusplus')}

# Get number of links
link_count = links.length

pdf_links = Array.new(link_count) { nil }

for i in 0..link_count
  # @bug possible html -> pdfl
  # @fix done, updated regex
  raw_link = links[i]['href'] unless links[i].nil?

  # Experimenting with long stuff
  pdf_links[i] = raw_link.
    split('/').
    insert(2, 'pdf').
    join('/').
    gsub(/htm(l)?/, 'pdf')
end

for i in 0..link_count
  filename = (i + 1).to_s << '-' << pdf_links[i].split('/')[3]
  Net::HTTP.start(DOMAIN) do |http|
    response = http.get(pdf_links[i])
    open(filename, 'wb') do |file|
      file.write(response.body)
    end
  end
end