# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'

class AuTest < Test::Unit::TestCase
  # au, 端末種別の識別
  def test_au_ca32
    reqs = request_with_ua("KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0",
                          "HTTP_X_UP_SUBNO"=>"00000000000000_mj.ezweb.ne.jp")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Au, req.mobile)
      assert_equal("00000000000000_mj.ezweb.ne.jp", req.mobile.subno)
      assert_equal("00000000000000_mj.ezweb.ne.jp", req.mobile.ident)
      assert_equal("00000000000000_mj.ezweb.ne.jp", req.mobile.ident_subscriber)
      assert(req.mobile.supports_cookie?)
    end
  end

  # TuKa, 端末種別の識別
  def test_tuka_tk22
    reqs = request_with_ua("UP.Browser/3.04-KCTA UP.Link/3.4.5.9")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Au, req.mobile)
    end
  end

  # 正しいIPアドレス空間からのアクセスを判断できるか。
  def test_au_valid_ip_address
    reqs = request_with_ua("KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0",
                          {"REMOTE_ADDR"=>"210.230.128.225"})
    reqs.each do |req|
      assert_equal(req.mobile.valid_ip?, true)
    end
  end

  # 正しくないIPアドレス空間からのアクセスを判断できるか。
  def test_au_invalid_ip_address
    reqs = request_with_ua("KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0",
                          {"REMOTE_ADDR"=>"127.0.0.1"})
    reqs.each do |req|
      assert_equal(req.mobile.valid_ip?, false)
    end
  end

  # 位置情報取得機能の有無, W31CA
  def test_au_location_capability_w31ca
    reqs = request_with_ua("KDDI-CA32 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0")
    reqs.each do |req|
      assert_equal("CA32", req.mobile.device_id)
    end
  end

  # 位置情報取得機能の有無, A1402S
  def test_au_location_capability_a1402s
    reqs = request_with_ua("KDDI-SN26 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0")
    reqs.each do |req|
      assert_equal("SN26", req.mobile.device_id)
    end
  end

  # 位置情報取得機能の有無, TK22
  def test_au_location_capability_tk22
    reqs = request_with_ua("UP.Browser/3.04-KCTA UP.Link/3.4.5.9")
    reqs.each do |req|
      assert_equal("KCTA", req.mobile.device_id)
    end
  end
end
