# frozen_string_literal: true
require_relative './bbs_2ch_url_validator/version'

module Bbs2chUrlValidator
  # http://www.rubular.com/r/nFpFxFptsZ
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

    private # rubocop:disable Lint/UselessAccessModifier # for yard

    # rubocop:disable Lint/IneffectiveAccessModifier
    def self.extract_and_sort_group_names
      VALID_2CH_URL_REGEX.named_captures.to_a \
        .sort { |a, b| a[1] <=> b[1] }.map { |n| n[0] } # rubocop:disable all
    end

    def self.generate_group_name_value_pairs(group_names, matchdata) # rubocop:disable all
      hash = {}
      group_names.each_with_index do |n, i|
        hash[n] = matchdata[i + 1]
      end
      hash
    end

    def self.remove_duplicate_key(hash) # rubocop:disable all
      hash['thread_key'] ||= hash['thread_key2']
      hash.delete('thread_key2')
      hash
    end
  end

  class UrlInfo
    # @return [String]
    attr_reader :server_name, :tld, :board_name, :thread_key, :built_url
    # @return [Boolean]
    # @deprecated
    attr_reader :is_dat, :is_subject, :is_setting, :is_open

    # @param [Hash] hash
    def initialize(hash)
      hash.each do |k, v|
        value = k.start_with?('is_') ? !v.nil? : v
        instance_variable_set("@#{k}", value)
      end
      @built_url = build_url
      define_methods
    end

    def dat
      generate_special_url(:dat)
    end

    def subject
      generate_special_url(:subject)
    end

    def setting
      generate_special_url(:setting)
    end

    private

    def define_methods
      %w(is_open is_dat is_subject is_setting).each do |attr|
        self.class.send(:define_method, attr.gsub(/is_(.+)/) { "#{$1}?" }) { attr }
      end
    end

    def build_url
      if @is_dat || @is_subject || @is_setting
        generate_special_url_by_flags
      elsif @thread_key
        # http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/
        combine_url("/test/read.cgi/#{@board_name}/#{@thread_key}/")
      elsif @board_name
        # http://viper.2ch.sc/news4vip/
        combine_url("/#{@board_name}/")
      else
        # http://2ch.sc http://www.2ch.sc
        combine_url(nil)
      end
    end

    def generate_special_url_by_flags
      if @is_dat
        generate_special_url(:dat)
      elsif @is_subject
        generate_special_url(:subject)
      elsif @is_setting
        generate_special_url(:setting)
      end
    end

    def generate_special_url(type)
      case type
      when :dat
        return nil unless @board_name && @thread_key
        # http://viper.2ch.sc/news4vip/dat/9990000001.dat
        combine_url("/#{@board_name}/dat/#{@thread_key}.dat")
      when :subject
        return nil unless @board_name
        # http://viper.2ch.sc/news4vip/subject.txt
        combine_url("/#{@board_name}/subject.txt")
      when :setting
        return nil unless @board_name
        # http://viper.2ch.sc/news4vip/SETTING.TXT
        combine_url("/#{@board_name}/SETTING.TXT")
      end
    end

    def combine_url(path)
      "http://#{generate_host_name}#{path}"
    end

    def generate_host_name
      "#{get_subdomain}#{get_2ch_name}.#{@tld}"
    end

    def get_subdomain
      @server_name ? "#{@server_name}." : nil
    end

    def get_2ch_name
      @is_open ? 'open2ch' : '2ch'
    end
  end
end
