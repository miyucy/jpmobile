# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'hpricot'

class FakeView
  include Jpmobile::Helpers
  def initialize
    @requiest = nil
  end
  def url_for(options={})
    return "http://example.jp"
  end
  attr_accessor :request
end

class HelpersTest < Test::Unit::TestCase
  def setup
    @view = FakeView.new
  end

  # DoCoMo 端末情報取得用のリンクが正しく出力されるか。
  def test_docomo_utn_link_to
    links = get_href_and_texts(@view.docomo_utn_link_to("STRING"))
    assert_equal(1, links.size)
    text,attrs,path,params = links.first
    assert_equal("STRING", text)
    assert_equal("http://example.jp", path)
    assert(attrs.to_hash.include?("utn"))
  end

  private
  # 文字列 +str+ 中に含まれるリンクについて、
  # リンクテキスト、属性のHash、URLのqueryをのぞいた部分、ueryをHashにしたもの
  # の3要素からなる配列の配列で返す。
  def get_href_and_texts(str)
    results = []
    (Hpricot(str)/:a).each do |link|
      path, query = link["href"].split(/\?/, 2)
      params = query.nil? ? nil : Rack::Utils.parse_query(query)
      results << [link.inner_html, link.attributes, path, params]
    end
    return results
  end
end
