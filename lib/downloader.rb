require 'net/http'

class Downloader < Net::HTTP

  class << self

    attr_reader :domain
    attr_reader :path
    attr_reader :http

    def create(domain, path)
      @domain = domain
      @path   = path
      @http   = Net::HTTP.new(domain).get(path)
      self
    end

    def get_page
      @http.body
    end

    def grab(remote = [], local = [], domain='www.tutorialspoint.com')
      for i in 0...remote.count
        filename = (i + 1).to_s << '-' << local[i]
        Net::HTTP.start(domain) do |http|
          response = http.get(remote[i])
          open(filename, 'wb') do |file|
            file.write(response.body)
          end
        end
      end
    end
  end

end
