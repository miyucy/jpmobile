# -*- coding: utf-8 -*-
# =Willcom携帯電話
# DDI-POCKETを含む。

module Jpmobile::Mobile
  # ==Willcom携帯電話
  # Ddipocketのスーパクラス。
  class Willcom < AbstractMobile
    autoload :IP_ADDRESSES, 'jpmobile/mobile/z_ip_addresses_willcom'

    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /^Mozilla\/3.0\(WILLCOM/
    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = /^.+@(.+\.)?pdx\.ne\.jp$/

    # cookieに対応しているか？
    def supports_cookie?
      true
    end
  end
  # ==DDI-POCKET
  # スーパクラスはWillcom。
  class Ddipocket < Willcom
    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /^Mozilla\/3.0\(DDIPOCKET/

    MAIL_ADDRESS_REGEXP = nil # DdipocketはEmail判定だとWillcomと判定させたい
  end
end
