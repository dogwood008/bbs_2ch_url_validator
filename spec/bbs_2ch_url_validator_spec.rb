# frozen_string_literal: true
require 'spec_helper'

describe Bbs2chUrlValidator do
  valid_urls = {
    top_sc: { url: 'http://www.2ch.sc',
              setting: nil,
              subject: nil,
              dat: nil,
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
                              setting: 'http://viper.open2ch.net/news4vip/SETTING.TXT',
                              subject: 'http://viper.open2ch.net/news4vip/subject.txt',
                              dat: 'http://viper.open2ch.net/news4vip/dat/1439127670.dat',
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

    describe 'Bbs2chUrlValidator.build_url' do
      shared_examples 'can build a valid url' do |url, generated_url|
        subject { Bbs2chUrlValidator::URL.parse(url) }
        its(:built_url) { should match generated_url }
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

  describe 'UrlInfo#setting' do
    shared_examples 'build setting url' do |original_url, result|
      let(:urlinfo) { Bbs2chUrlValidator::URL.parse(original_url) }
      subject { urlinfo.setting }
      it { should eq result }
    end
    context 'build url suceessfully' do
      original_url = valid_urls[:thread_open_with_slash][:url]
      result = valid_urls[:thread_open_with_slash][:setting]
      it_behaves_like 'build setting url', original_url, result
    end
    context 'fail when some parameters lacked' do
      original_url = valid_urls[:top_sc][:url]
      result = valid_urls[:top_sc][:setting]
      it_behaves_like 'build setting url', original_url, result
    end
  end

  describe 'build urls' do
    shared_examples 'build url' do |method, url_type |
      let(:original_url) { valid_urls[url_type][:url] }
      let(:result) { valid_urls[url_type][method] }
      let(:urlinfo) { Bbs2chUrlValidator::URL.parse(original_url) }
      subject { urlinfo.method(method).call }
      it { should eq result }
    end

    [:subject, :dat, :setting].each do |type|
      describe "UrlInfo##{type}" do
        context 'build url suceessfully' do
          it_behaves_like 'build url', type, :thread_open_with_slash
        end
        context 'fail when some parameters lacked' do
          it_behaves_like 'build url', type, :top_sc
        end
      end
    end
  end
end
