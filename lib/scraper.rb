require 'nokogiri'

require_relative 'helpers/helpers'
require_relative 'downloader'
require_relative 'procs'

class LinkSet < Array

  class << self

    attr_accessor :links

    def create(page, property, subject, selector = 'div#leftcol > ul.menu > li > a')
      @links = {
        pdf:    [],
        raw:    [],
        file:   [],
        count:  0
      }

      @links[:raw] = Nokogiri::HTML(page).
        css(selector).
        select { |link| B_SELECT_BY_SUBJECT.call(link, property, subject) }.
        map { |link| link[property] }

      @links[:count] = @links[:raw].length

      @links[:pdf] = @links[:raw].map { |link| B_MAP_TO_PDF.call(link) }

      @links[:file] = @links[:pdf].map{ |link| link.split('/')[3] }

      self

    end

  end

end
