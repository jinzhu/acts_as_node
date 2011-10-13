class Node < ActiveRecord::Base
  class << self
    def current=(language)
      Thread.current["current_language"] = language
    end

    def current
      Thread.current["current_language"] || Node.first
    end
  end
end
