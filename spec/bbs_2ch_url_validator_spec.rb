# frozen_string_literal: true
require 'spec_helper'

describe Bbs2chUrlValidator do
  valid_urls = {
    top_sc: { url: 'http://www.2ch.sc',
              params: { server_name: 'www', tld: 'sc' } },
    top_open: { url: 'http://open2ch.net',
                params: { is_open: true, tld: 'net' } },
    top_sc_ends_with_slash: { url: 'http://www.2ch.sc/',
                              params: { server_name: 'www', tld: 'sc' } },
    top_open_ends_with_slash: { url: 'http://open2ch.net/',
                                params: { is_open: true, tld: 'net' } },
    board_sc: { url: 'http://viper.2ch.sc/news4vip',
                params: { server_name: 'viper', board_name: 'news4vip', tld: 'sc' } },
    board_open: { url: 'http://viper.open2ch.net/news4vip',
                  params: { is_open: true, server_name: 'viper', board_name: 'news4vip', tld: 'net' } },
    board_sc_ends_with_slach: { url: 'http://viper.2ch.sc/news4vip',
                                params: { server_name: 'viper', board_name: 'news4vip', tld: 'sc' } },
    board_open_ends_with_slach: { url: 'http://viper.open2ch.net/news4vip',
                                  params: { is_open: true, server_name: 'viper', board_name: 'news4vip', tld: 'net' } },
    dat_sc: { url: 'http://viper.2ch.sc/news4vip/dat/9990000001.dat',
              params: { is_dat: true, server_name: 'viper', board_name: 'news4vip', \
                        thread_key: '9990000001', tld: 'sc' } },
    dat_open: { url: 'http://viper.open2ch.net/news4vip/dat/1439127670.dat',
                params: { is_open: true, is_dat: true, server_name: 'viper', board_name: 'news4vip',
                          thread_key: '1439127670', tld: 'net' } },
    subject_sc: { url: 'http://viper.2ch.sc/news4vip/subject.txt',
                  params: { is_subject: true, server_name: 'viper', board_name: 'news4vip', tld: 'sc' } },
    subject_open: { url: 'http://viper.open2ch.net/news4vip/subject.txt',
                  params: { is_open: true, is_subject: true, server_name: 'viper', board_name: 'news4vip', tld: 'net' } },
    setting_sc: { url: 'http://viper.2ch.sc/news4vip/SETTING.TXT',
                  params: { is_setting: true, server_name: 'viper', board_name: 'news4vip', tld: 'sc' } },
    setting_open: { url: 'http://viper.open2ch.net/news4vip/SETTING.TXT',
                  params: { is_open: true, is_setting: true, server_name: 'viper', board_name: 'news4vip', tld: 'net' } },
    thread_sc: { url: 'http://viper.2ch.sc/test/read.cgi/news4vip/9990000001',
                  params: { thread_key: '9990000001' , server_name: 'viper', board_name: 'news4vip', tld: 'sc' } },
    thread_open: { url: 'http://viper.open2ch.net/test/read.cgi/news4vip/1439127670',
                  params: { thread_key: '1439127670', is_open: true, server_name: 'viper',\
                            board_name: 'news4vip', tld: 'net' } },
    thread_sc_with_slash: { url: 'http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/',
                  params: { thread_key: '9990000001' , server_name: 'viper', board_name: 'news4vip', tld: 'sc' } },
    thread_open_with_slash: { url: 'http://viper.open2ch.net/test/read.cgi/news4vip/1439127670/',
                  params: { thread_key: '1439127670', is_open: true, server_name: 'viper',\
                            board_name: 'news4vip', tld: 'net' } }
  }
  invalid_urls = {
    yahoo: { url: 'http://yahoo.co.jp', params: {} },
    google: { url: 'http://www.google.com', params: {} },
    broken: { url: 'abc://def{}.ghi', params: {} }
  }

  it 'has a version number' do
    expect(Bbs2chUrlValidator::VERSION).not_to be nil
  end

  describe '#parse' do
    shared_examples 'can parse a 2ch url' do
      subject { Bbs2chUrlValidator::URL.parse(url) }
      its(:server_name) { should match params[:server_name] }
      its(:tld) { should match params[:tld] }
      its(:board_name) { should match params[:board_name] }
      its(:thread_key) { should match params[:thread_key] }
      its(:is_dat) { should be !params[:is_dat].nil? }
      its(:is_subject) { should be !params[:is_subject].nil? }
      its(:is_setting) { should be !params[:is_setting].nil? }
    end

    shared_examples 'check given urls' do |urls|
      urls.each do |k, v|
        describe k do
          it_behaves_like 'can parse a 2ch url' do
            let(:url) { v[:url] }
            let(:params) { v[:params] }
          end
        end
      end
    end

    context 'when given was a valid url' do
      it_behaves_like 'check given urls', valid_urls
    end

    context 'when given was a invalid url' do
      invalid_urls.each do |u|
        subject { Bbs2chUrlValidator::URL.parse(u) }
        it { should be_nil }
      end
    end
  end

  describe '#build_url' do
    shared_examples 'can build a valid url' do |url, generated_url|
      subject { b = Bbs2chUrlValidator::URL.parse(url); b.build_url }
      it { should match generated_url }
    end
    urls = [
      {
        url: 'http://2ch.sc',
        generated_url: 'http://2ch.sc'
      }, {
        url: 'http://www.2ch.sc',
        generated_url: 'http://www.2ch.sc'
      }, {
        url: 'http://open2ch.net',
        generated_url: 'http://open2ch.net'
      }, {
        url: 'http://2ch.sc/',
        generated_url: 'http://2ch.sc'
      }, {
        url: 'http://www.2ch.sc/',
        generated_url: 'http://www.2ch.sc'
      }, {
        url: 'http://open2ch.net/',
        generated_url: 'http://open2ch.net'
      }, {
        url: 'http://viper.2ch.sc/news4vip',
        generated_url: 'http://viper.2ch.sc/news4vip/'
      }, {
        url: 'http://viper.open2ch.net/news4vip',
        generated_url: 'http://viper.open2ch.net/news4vip/'
      }, {
        url: 'http://viper.2ch.sc/news4vip/',
        generated_url: 'http://viper.2ch.sc/news4vip/'
      }, {
        url: 'http://viper.open2ch.net/news4vip/',
        generated_url: 'http://viper.open2ch.net/news4vip/'
      }, {
        url: 'http://viper.2ch.sc/news4vip/dat/9990000001.dat',
        generated_url: 'http://viper.2ch.sc/news4vip/dat/9990000001.dat'
      }, {
        url: 'http://viper.open2ch.net/news4vip/dat/1439127670.dat',
        generated_url: 'http://viper.open2ch.net/news4vip/dat/1439127670.dat'
      }, {
        url: 'http://viper.2ch.sc/news4vip/subject.txt',
        generated_url: 'http://viper.2ch.sc/news4vip/subject.txt'
      }, {
        url: 'http://viper.open2ch.net/news4vip/subject.txt',
        generated_url: 'http://viper.open2ch.net/news4vip/subject.txt'
      }, {
        url: 'http://viper.2ch.sc/news4vip/SETTING.TXT',
        generated_url: 'http://viper.2ch.sc/news4vip/SETTING.TXT'
      }, {
        url: 'http://viper.open2ch.net/news4vip/SETTING.TXT',
        generated_url: 'http://viper.open2ch.net/news4vip/SETTING.TXT'
      }, {
        url: 'http://viper.2ch.sc/test/read.cgi/news4vip/9990000001',
        generated_url: 'http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/'
      }, {
        url: 'http://viper.open2ch.net/test/read.cgi/news4vip/1439127670',
        generated_url: 'http://viper.open2ch.net/test/read.cgi/news4vip/1439127670'
      }, {
        url: 'http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/',
        generated_url: 'http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/'
      }, {
        url: 'http://viper.open2ch.net/test/read.cgi/news4vip/1439127670/',
        generated_url: 'http://viper.open2ch.net/test/read.cgi/news4vip/1439127670/'
      }
    ]
    urls.each do |u|
      it_behaves_like 'can build a valid url', u[:url], u[:generated_url]
    end
  end
end
