# frozen_string_literal: true

module SymbolizeKeys
  module_function def symbolize(hash)
    hash.each_with_object({}) { |(key, value), new_hash| new_hash[key.to_sym] = value }
  end
end
