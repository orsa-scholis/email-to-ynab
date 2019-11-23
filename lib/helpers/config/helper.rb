# frozen_string_literal: true

require 'json-schema'
require 'pathname'

module Helpers
  module Config
    class Helper
      SCHEMA_PATH = './lib/helpers/config/schema.json'
      DEFAULT_PATH = Pathname.new('./config.yaml').freeze

      def validate!(path = DEFAULT_PATH)
        JSON::Validator.validate!(schema_raw, config(path))
      end

      def transfer_ids
        @transfer_ids ||= config[:transfer_ids]
      end

      def accounts
        @accounts ||= config[:accounts]
      end

      def payee_name_regexps
        @payee_name_regexps ||= config[:payee_name_regexps].map do |raw_regexp|
          Regexp.new(raw_regexp)
        end
      end

      def email_parts_regexps
        @email_parts_regexps ||= config[:email_parts_regexps].map do |key, raw_regexp|
          parsed_regex = Regexp.new(raw_regexp)
          parsed_regex = Regexp.new(raw_regexp, Regexp::MULTILINE) if key == :memo
          {key => parsed_regex}
        end.reduce({}, :merge)
      end

      private

      def config_raw(path = DEFAULT_PATH)
        @config_raw ||= File.read(path)
      end

      def config(path = DEFAULT_PATH)
        @config ||= YAML.safe_load(config_raw(path), symbolize_names: true)
      end

      def schema_raw(path = SCHEMA_PATH)
        @schema_raw ||= File.read(path)
      end
    end
  end
end