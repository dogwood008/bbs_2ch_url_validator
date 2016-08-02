# frozen_string_literal: true
require_relative './bbs_2ch_url_validator/version'

module Bbs2chUrlValidator
  # http://www.rubular.com/r/UEVtzBwbtM
  VALID_2CH_URL_REGEX = %r(^http:\/\/((?<server_name>.+)\.)?(?<is_open>open)?2ch.(?<tld>net|sc)\/?((test\/read\.cgi\/)?(?<board_name>\w+?)\/?((?<thread_key>\d{9,10})\/?)?)?((?<is_dat>dat)\/(?<thread_key2>\d{9,10})\.dat)?((?<is_subject>subject)\.txt)?((?<is_setting>SETTING)\.TXT)?$) # rubocop:disable Metrics/LineLength

  class URL
    # @params [URI or String] url URL
    # @return [UrlInfo] URLInfo
    def self.parse(url)
      VALID_2CH_URL_REGEX.match(url.to_s) do |m|
        hash = generate_group_name_value_pairs(extract_and_sort_group_names, m)
        hash = remove_duplicate_key(hash)
        UrlInfo.new(hash)
      end
    end

    # @params [URI or String] url URL
    def self.valid?(url)
      !parse(url).nil?
    end

    class << self
      private # rubocop:disable Lint/UselessAccessModifier # for yard

      def self.extract_and_sort_group_names
        VALID_2CH_URL_REGEX.named_captures.to_a \
                           .sort { |a, b| a[1] <=> b[1] }.map { |n| n[0] }
      end

      def self.generate_group_name_value_pairs(group_names, matchdata)
        hash = {}
        group_names.each_with_index do |n, i|
          hash[n] = matchdata[i + 1]
        end
        hash
      end

      def self.remove_duplicate_key(hash)
        hash['thread_key'] = hash['thread_key'] || hash['thread_key2']
        hash.delete('thread_key2')
        hash
      end
    end
  end

  class UrlInfo
    attr_reader :server_name, :tld, :board_name, :thread_key, :is_open, \
                :is_dat, :is_subject, :is_setting
    def initialize(hash)
      hash.each do |k, v|
        value = k.start_with?('is_') ? !v.nil? : v
        instance_variable_set("@#{k}", value)
      end
    end
  end
end
