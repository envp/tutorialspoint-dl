#!/usr/bin/ruby -w
# A simple script that acquires PDF files from http://www.tutorialspoint.com/
#
# Created by unsignedzero (David Tran) and vaibhav-y (Vaibhav Yenamandra)
# File created: 12-25-2013
# Last Modified: 12-28-2013
# Version 0.1.0.0

require 'rubygems'
require 'nokogiri'
require 'net/http'

def tpDLER( protocol='http', domain='www.tutorialspoint.com' )
  # Remote is too slow, try to implement later for local copy
  links = Nokogiri::HTML(Net::HTTP.get(domain, '/cplusplus/index.htm')).
    css('div#leftcol > ul.menu > li > a')

  # Filter out anything that is not course material
  links = links.select { |link| link if link['href'].include? 'cplusplus'}

  # Get number of links
  link_count = links.length

  pdf_links = Array.new(link_count) { nil }

  for i in 0..link_count
    # @bug possible html -> pdfl
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
    Net::HTTP.start(domain) do |http|
      response = http.get(pdf_links[i])
      open(filename, 'wb') do |file|
        file.write(response.body)
      end
    end
  end
end

tpDLER
