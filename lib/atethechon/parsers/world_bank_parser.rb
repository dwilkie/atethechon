require "nokogiri"
require "open-uri"
require "yaml"
require "countries"
require "phony"

module Atethechon
  class WorldBankParser
    REGIONS = {
      afr: "Africa",
      eap: "East Asia and Pacific",
      eca: "Europe and Central Asia",
      lac: "Latin America and Caribbean",
      mena: "Middle East and North Africa",
      sar: "South Asia"
    }.freeze

    ORGANIZATION_IDENTIFIER = "world_bank".freeze
    CONTACTS_URL = "https://www.worldbank.org/en/region/%<region_id>s/contacts".freeze
    COUNTRY_NAMES = ISO3166::Country.all.map.freeze
    MANUAL_LOCATIONS_MAPPING = {
      "korea" => "KR",
      "democratic republic of congo" => "CD",
      "republic of congo" => "CG",
      "cote d’ivoire" => "CI",
      "türkiye" => "TR",
      "lao pdr" => "LA"
    }.freeze

    def parse
      fetch_contacts
    end

    private

    def fetch_contacts
      REGIONS.each_with_object([]) do |(region_id, region_name), result|
        page = fetch_contacts_page(region_id)

        each_contact_on(page) { |data| result << build_contact(data, region_name) }
      end
    end

    def fetch_contacts_page(region_id)
      contacts_url = format(CONTACTS_URL, region_id:)
      Nokogiri::HTML(URI.parse(contacts_url).open)
    end

    def each_contact_on(page, &block)
      page.xpath("//*[contains(@class, 'c14v1-contacts-row')]//*[contains(@class, 'c14v1-contacts')]").each(&block)
    end

    def build_contact(data, region)
      contact = parse_contact_data(data)
      contact.region = region
      contact
    end

    def parse_contact_data(data)
      heading = data.xpath(".//*[substring-after(name(), 'h') > 0]/text()").text.strip
      location = data.xpath(".//*[contains(@class, 'location')]/text()").text.strip
      name = data.xpath(".//*[contains(@class, 'name')]/text()").text.strip.split(/\s+/).join(" ")
      email = data.xpath(".//a[contains(@href, 'mailto:')]/@href").text.sub(/\Amailto:/, "")
      phone_number = data.xpath(".//*[contains(text(), 'Tel')]/text()").text
                         .gsub(/Tel\s*:/i, "")
                         .gsub(/ext\s*\d+/i, "")
                         .gsub(/\D+/, "").strip

      Contact.new(
        name:,
        email:,
        country: resolve_location(heading, location),
        phone_number: format_phone_number(phone_number)
      )
    end

    def format_phone_number(number)
      return if number.empty?

      Phony.format(number)
    rescue Phony::FormattingError
      number
    end

    def resolve_location(*names)
      result = nil

      names.each do |name|
        country ||= find_country_by_mapping(name)
        country ||= find_country_by_name(name)

        result = country&.common_name
        result ||= multiple_locations(name)

        break unless result.nil?
      end

      result
    end

    def find_country_by_name(name)
      name = name.strip.downcase
      ISO3166::Country.all.find do |c|
        return c if c.iso_long_name.downcase == name
        return c if c.iso_short_name.downcase == name
        return c if c.common_name.downcase == name
        return c if c.unofficial_names.map(&:downcase).include?(name)
      end
    end

    def find_country_by_mapping(name)
      alpha2 = MANUAL_LOCATIONS_MAPPING[name.strip.downcase]
      return if alpha2.nil?

      ISO3166::Country.find_country_by_alpha2(alpha2)
    end

    def multiple_locations(name)
      return unless name.include?(",")

      names = name.split(",").map { |n| find_country_by_name(n)&.common_name }.compact
      names.join(", ") unless names.empty?
    end
  end
end
