require "yaml"
require "pathname"

module Atethechon
  class ContactParser
    attr_reader :data_directory

    def initialize(options = {})
      @data_directory = options.fetch(:data_directory) { Pathname.new(File.expand_path("..", File.dirname(__dir__))).join("data") }
    end

    def load
      Dir[data_directory.join("**/*.yml")].sort.each_with_object([]) do |data_file, result|
        data = YAML.load_file(data_file)
        data.each do |_organization_identifier, attributes|
          attributes.fetch("contacts").each do |contact_data|
            result << Contact.new(contact_data)
          end
        end
      end
    end
  end
end
