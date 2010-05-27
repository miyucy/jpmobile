# -*- coding: utf-8 -*-
module Jpmobile
  module Helpers
    # DoCoMoで端末製造番号等を取得するためのリンクを返す。
    def docomo_utn_link_to(str, options={})
      url = options
      if options.is_a?(Hash)
        options = options.symbolize_keys
        options[:only_path] = false
        url = url_for(options)
      end
      return %{<a href="#{url}" utn>#{str}</a>}
    end

    # DoCoMoでiモードIDを取得するためのリンクを返す。
    def docomo_guid_link_to(str, options={})
      url = options
      if options.is_a?(Hash)
        options = options.symbolize_keys
        options[:guid] = "ON"
        url = url_for(options)
      end
      return link_to_url(str, url)
    end

    private
    # 外部へのリンク
    def link_to_url(str, url)
      %{<a href="#{url}">#{str}</a>}
    end
  end
end
