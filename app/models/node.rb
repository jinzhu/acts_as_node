class Node < ActiveRecord::Base
  class << self
    def current=(language)
      Thread.current["_current_node"] = language
    end

    def current
      Thread.current["_current_node"] || Node.first
    end
  end
end
