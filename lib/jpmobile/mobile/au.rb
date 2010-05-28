# -*- coding: utf-8 -*-
# =au携帯電話

require 'ipaddr'

module Jpmobile::Mobile
  # ==au携帯電話
  # CDMA 1X, CDMA 1X WINを含む。
  class Au < AbstractMobile
    autoload :IP_ADDRESSES, 'jpmobile/mobile/z_ip_addresses_au'

    # 対応するUser-Agentの正規表現
    # User-Agent文字列中に "UP.Browser" を含むVodafoneの端末があるので注意が必要
    USER_AGENT_REGEXP = /^(?:KDDI|UP.Browser\/.+?)-(.+?) /
    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = /^.+@ezweb\.ne\.jp$/

    # EZ番号(サブスクライバID)があれば返す。無ければ +nil+ を返す。
    def subno
      @request.env["HTTP_X_UP_SUBNO"]
    end
    alias :ident_subscriber :subno

    # デバイスIDを返す
    def device_id
      if @request.env['HTTP_USER_AGENT'] =~ USER_AGENT_REGEXP
        return $1
      else
        nil
      end
    end

    # cookieに対応しているか？
    def supports_cookie?
      protocol = @request.respond_to?(:scheme) ? @request.scheme : @request.protocol rescue "none"
      if protocol =~ /\Ahttps/
        false
      else
        true
      end
    end
  end
end
