# -*- coding: utf-8 -*-
# =SoftBank携帯電話
# J-PHONE, Vodafoneを含む

require 'nkf'

module Jpmobile::Mobile
  # ==Softbank携帯電話
  # Vodafoneスーパクラス。
  class Softbank < AbstractMobile
    autoload :IP_ADDRESSES, 'jpmobile/mobile/z_ip_addresses_softbank'

    # 対応するuser-agentの正規表現
    USER_AGENT_REGEXP = /^(?:SoftBank|Semulator)/
    # 対応するメールアドレスの正規表現　ディズニーモバイル対応
    MAIL_ADDRESS_REGEXP = /^.+@(?:softbank\.ne\.jp|disney\.ne\.jp)$/

    # 製造番号を返す。無ければ +nil+ を返す。
    def serial_number
      @request.env['HTTP_USER_AGENT'] =~ /SN(.+?) /
      return $1
    end
    alias :ident_device :serial_number

    # UIDを返す。
    def x_jphone_uid
      @request.env["HTTP_X_JPHONE_UID"]
    end
    alias :ident_subscriber :x_jphone_uid

    # 画面情報を +Display+ クラスのインスタンスで返す。
    def display
      return @__display if @__display
      p_w = p_h = col_p = cols = nil
      if r = @request.env['HTTP_X_JPHONE_DISPLAY']
        p_w, p_h = r.split(/\*/,2).map {|x| x.to_i}
      end
      if r = @request.env['HTTP_X_JPHONE_COLOR']
        case r
        when /^C/
          col_p = true
        when /^G/
          col_p = false
        end
        if r =~ /^.(\d+)$/
          cols = $1.to_i
        end
      end
      @__display = Jpmobile::Display.new(p_w, p_h, nil, nil, col_p, cols)
    end

    # cookieに対応しているか？
    def supports_cookie?
      true
    end
  end
  # ==Vodafone 3G携帯電話(J-PHONE, SoftBank含まず)
  # スーパクラスはSoftbank。
  class Vodafone < Softbank
    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /^(Vodafone|Vemulator)/
    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = /^.+@[dhtcrknsq]\.vodafone\.ne\.jp$/

    # cookieに対応しているか？
    def supports_cookie?
      true
    end
  end
end
