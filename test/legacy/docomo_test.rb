# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'

class DocomoTest < Test::Unit::TestCase
  # DoCoMo, 端末種別の識別
  def test_docomo_sh902i
    reqs = request_with_ua("DoCoMo/2.0 SH902i(c100;TB;W24H12)")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Docomo, req.mobile)
      assert_equal(nil, req.mobile.serial_number)
      assert_equal(nil, req.mobile.icc)
      assert_equal(nil, req.mobile.ident)
      assert_equal(nil, req.mobile.ident_device)
      assert_equal(nil, req.mobile.ident_subscriber)
      assert(!req.mobile.supports_cookie?)
    end
  end

  # DoCoMo, 端末種別の識別
  def test_docomo_so506i
    reqs = request_with_ua("DoCoMo/1.0/SO506iC/c20/TB/W20H10")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Docomo, req.mobile)
      assert_equal(nil, req.mobile.serial_number)
      assert_equal(nil, req.mobile.icc)
      assert_equal(nil, req.mobile.ident)
      assert_equal(nil, req.mobile.ident_device)
      assert_equal(nil, req.mobile.ident_subscriber)
    end
  end

  # DoCoMo, utn, mova
  def test_docomo_utn_mova
    reqs = request_with_ua("DoCoMo/1.0/SO505iS/c20/TC/W30H16/serXXXXX000000")
    reqs.each do |req|
      assert_equal("XXXXX000000", req.mobile.serial_number)
      assert_equal("XXXXX000000", req.mobile.ident)
      assert_equal(nil, req.mobile.icc)
      assert_equal("XXXXX000000", req.mobile.ident_device)
      assert_equal(nil, req.mobile.ident_subscriber)
    end
  end

  # DoCoMo, utn, foma
  def test_docomo_utn_foma
    reqs = request_with_ua("DoCoMo/2.0 D902i(c100;TB;W23H16;ser999999999999999;icc0000000000000000000f)")
    reqs.each do |req|
      assert_equal("999999999999999", req.mobile.serial_number)
      assert_equal("0000000000000000000f", req.mobile.icc)
      assert_equal("0000000000000000000f", req.mobile.ident)
      assert_equal("999999999999999", req.mobile.ident_device)
      assert_equal("0000000000000000000f", req.mobile.ident_subscriber)
    end
  end

  # 正しいIPアドレス空間からのアクセスを判断できるか。
  def test_docomo_valid_ip_address
    reqs = request_with_ua("DoCoMo/2.0 SH902i(c100;TB;W24H12)",
                          {"REMOTE_ADDR"=>"210.153.84.1"})
    reqs.each do |req|
      assert_equal(true, req.mobile.valid_ip?)
    end
  end

  # 正しくないIPアドレス空間からのアクセスを判断できるか。
  def test_docomo_invalid_ip_address
    reqs = request_with_ua("DoCoMo/2.0 SH902i(c100;TB;W24H12)",
                          {"REMOTE_ADDR"=>"127.0.0.1"})
    reqs.each do |req|
      assert_equal(false, req.mobile.valid_ip?)
    end
  end
end
