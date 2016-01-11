module LogParser
  class Configuration
    # 設定値格納クラス
  end

  class << self
    # 設定値参照・変更用メソッドがある
  end

  module Record
    # レコードパーサーがある
  end

  module Record::Content
    # レコードオブジェクト

    class Base
      # レコード要素の抽象基底クラス
    end

    class User < Base
      # ユーザIDを格納
    end

    class PC < Base
      # クライアントIDを格納
    end

    class UseDateTime < Base
      # 使用日時を格納
    end
  end
end

# depends
require 'singleton'
require 'yaml'

# load
require 'log_parser/version'
require 'log_parser/configuration'
require 'log_parser/record/content/base'
require 'log_parser/record/content/user'
