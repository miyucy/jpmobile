# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'

class SoftbankTest < Test::Unit::TestCase
  # SoftBank, 端末種別の識別
  def test_softbank_910t
    reqs = request_with_ua("SoftBank/1.0/910T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Softbank, req.mobile)
      assert_kind_of(Jpmobile::Mobile::Softbank, req.mobile)
      assert_equal("000000000000000", req.mobile.serial_number)
      assert_equal("000000000000000", req.mobile.ident)
      assert_equal("000000000000000", req.mobile.ident_device)
      assert_equal(nil, req.mobile.ident_subscriber)
      assert(req.mobile.supports_cookie?)
    end
  end

  # SoftBank, X_JPHONE_UID付き
  def test_softbank_910t_x_jphone_uid
    reqs = request_with_ua("SoftBank/1.0/910T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1", "HTTP_X_JPHONE_UID"=>"aaaaaaaaaaaaaaaa")
    reqs.each do |req|
      assert_equal("000000000000000", req.mobile.serial_number)
      assert_equal("aaaaaaaaaaaaaaaa", req.mobile.x_jphone_uid)
      assert_equal("aaaaaaaaaaaaaaaa", req.mobile.ident)
      assert_equal("000000000000000", req.mobile.ident_device)
      assert_equal("aaaaaaaaaaaaaaaa", req.mobile.ident_subscriber)
      assert(req.mobile.supports_cookie?)
    end
  end

  # Vodafone, 端末種別の識別
  def test_vodafone_v903t
    reqs = request_with_ua("Vodafone/1.0/V903T/TJ001 Browser/VF-Browser/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 Ext-J-Profile/JSCL-1.2.2 Ext-V-Profile/VSCL-2.0.0")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Vodafone, req.mobile)
      assert_kind_of(Jpmobile::Mobile::Softbank, req.mobile)
      assert_equal(nil, req.mobile.ident)
      assert(req.mobile.supports_cookie?)
    end
  end

  # Vodafone, 端末種別の識別
  def test_vodafone_v903sh
    reqs = request_with_ua("Vodafone/1.0/V903SH/SHJ001/SN000000000000000 Browser/UP.Browser/7.0.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1 Ext-J-Profile/JSCL-1.2.2 Ext-V-Profile/VSCL-2.0.0")
    reqs.each do |req|
      assert_equal(true, req.mobile?)
      assert_instance_of(Jpmobile::Mobile::Vodafone, req.mobile)
      assert_kind_of(Jpmobile::Mobile::Softbank, req.mobile)
      assert_equal("000000000000000", req.mobile.serial_number)
      assert_equal("000000000000000", req.mobile.ident)
      assert_equal("000000000000000", req.mobile.ident_device)
      assert_equal(nil, req.mobile.ident_subscriber)
      assert(req.mobile.supports_cookie?)
    end
  end

  # 正しいIPアドレス空間からのアクセスを判断できるか。
  def test_softbank_valid_ip_address
    reqs = request_with_ua("Vodafone/1.0/V903T/TJ001 Browser/VF-Browser/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 Ext-J-Profile/JSCL-1.2.2 Ext-V-Profile/VSCL-2.0.0",
                          {"REMOTE_ADDR"=>"202.179.204.1"})
    reqs.each do |req|
      assert_equal(true, req.mobile.valid_ip?)
    end
  end

  # 正しくないIPアドレス空間からのアクセスを判断できるか。
  def test_softbank_ip_address
    reqs = request_with_ua("Vodafone/1.0/V903T/TJ001 Browser/VF-Browser/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 Ext-J-Profile/JSCL-1.2.2 Ext-V-Profile/VSCL-2.0.0",
                          {"REMOTE_ADDR"=>"127.0.0.1"})
    reqs.each do |req|
      assert_equal(false, req.mobile.valid_ip?)
    end
  end
end
