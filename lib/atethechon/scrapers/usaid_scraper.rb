require "nokogiri"
require "open-uri"
require "yaml"
require "countries"
require "phony"

module Atethechon
  class USAIDParser
    MISSION_DIRECTORY_URL = "https://www.usaid.gov/mission-directory".freeze

    def scrape
      fetch_contacts
    end

    private

    def fetch_contacts
      directory = Nokogiri::HTML(URI.parse(MISSION_DIRECTORY_URL).open)
      page.xpath("//*[contains(@class, 'view-country-missions')]//*[contains(@class, 'c14v1-contacts')]").each(&block)
    end
  end
end
