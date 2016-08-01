require_relative './bbs_2ch_url_validator/version'
require 'uri'

module Bbs2chUrlValidator
  # http://www.rubular.com/r/UEVtzBwbtM
  VALID_2CH_URL_REGEX = %r(^http:\/\/((?<server_name>.+)\.)?(?<open_flag>open)?2ch.(?<tld>net|sc)\/?((test\/read\.cgi\/)?(?<board_name>\w+?)\/?((?<thread_key>\d{10,11})\/?)?)?((?<dat_flag>dat)\/(?<thread_key2>\d{10,11})\.dat)?((?<subject_flag>subject)\.txt)?((?<setting_flag>SETTING)\.TXT)?$)

  class URL
    def self.parse(url)
      URI.parse(url)
      group_names = VALID_2CH_URL_REGEX.named_captures.to_a.sort {|a,b| a[1] <=> b[1] }.map {|n| n[0]}
      VALID_2CH_URL_REGEX.match(url) do |m|
        hash = {}
        group_names.each_with_index do |n, i|
          hash[n] = m[i+1]
        end
        hash['thread_key'] = hash['thread_key'] || hash['thread_key2']
        hash.delete('thread_key2')
        UrlInfo.new(hash)
      end
    end
  end

  class UrlInfo
    attr_reader :server_name, :tld, :board_name, :thread_key, :open_flag, \
      :dat_flag, :subject_flag, :setting_flag
    def initialize(hash)
      hash.each do |k, v|
        value = k.end_with?('flag') ? !v.nil? : v
        instance_variable_set("@#{k}", value)
      end
    end
  end
end
