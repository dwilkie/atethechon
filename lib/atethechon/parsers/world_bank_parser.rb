require "nokogiri"
require "open-uri"
require "yaml"

module Atethechon
  class WorldBankParser
    REGIONS = %i[afr eap eca lac mena sar].freeze
    CONTACTS_URL = "https://www.worldbank.org/en/region/%{region_id}/contacts".freeze

    def initialize; end

    def parse
      REGIONS.each do |region_id|
        contacts_url = format(CONTACTS_URL, region_id:)
        page = Nokogiri::HTML(URI.parse(contacts_url).open)

        data = {}
        page.xpath('//*[@id="content"]/section[1]/table/tbody/tr').each do |row|
          mcc = row.xpath('.//td[2]').text
          data[mcc] = {
            "title" => row.xpath(".//td[1]/text()").text,
            "category" => row.xpath(".//td[1]/code").text
          }
        end
      end
    end
  end
end
