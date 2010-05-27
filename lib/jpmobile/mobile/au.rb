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

    # 画面情報を +Display+ クラスのインスタンスで返す。
    def display
      return @__display if @__display

      p_w = p_h = col_p = cols = nil
      if r = @request.env['HTTP_X_UP_DEVCAP_SCREENPIXELS']
        p_w, p_h = r.split(/,/,2).map {|x| x.to_i}
      end
      if r = @request.env['HTTP_X_UP_DEVCAP_ISCOLOR']
        col_p = (r == '1')
      end
      if r = @request.env['HTTP_X_UP_DEVCAP_SCREENDEPTH']
        a = r.split(/,/)
        cols = 2 ** a[0].to_i
      end
      @__display = Jpmobile::Display.new(p_w, p_h, nil, nil, col_p, cols)
    end

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
