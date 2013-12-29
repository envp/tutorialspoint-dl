require_relative 'downloader'
require_relative 'scraper'
require_relative 'constants'

def boot(subject)
  downloader = Downloader.create(Domain, '/' | subject | BasePath)
  link_set   = LinkSet.create(downloader.get_page, Property, subject)
  downloader.grab(link_set.links[:pdf], link_set.links[:file])
end
