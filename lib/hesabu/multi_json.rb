module Hesabu
  # A wrapper to support both `oj` and normal `json`
  #
  # `oj` has some characteristics which make a very good candidate to
  # be the preferred JSON parser for Hesabu. Mainly, it's fast, and it
  # stays fast for large payloads.
  #
  # This module will check if `oj` is available and otherwise fall
  # back to the regular JSON from the standard lib
  #
  #      Hesabu::MultiJSON::generate(object) # Generate JSON
  #      Hesabu::MultiJSON::parse(string) # Parse JSON
  module MultiJSON

    # Takes a ruby object and transforms it to JSON.
    def self.generate(object)
      _fast_to_json(object)
    rescue NameError
      define_fast_json(Hesabu::MultiJSON, "to_json")
      _fast_to_json(object)
    end

    # Takes a string (hopefully containing JSON) and parses it to Ruby
    def self.parse(string)
      _fast_from_json(string)
    rescue NameError
      define_fast_json(Hesabu::MultiJSON, "from_json")
      _fast_from_json(string)
    end

    def self.to_json_method
      body = begin
               require "oj"
               %(::Oj.dump(object, mode: :compat, time_format: :ruby, use_to_json: true))
             rescue LoadError
               %(JSON.fast_generate(object, create_additions: false, quirks_mode: true))
             end
      <<~METHOD
        def _fast_to_json(object)
          #{body}
        end
METHOD
    end

    def self.from_json_method
      body = begin
               require "oj"
               %(::Oj.load(string, mode: :compat, time_format: :ruby, use_to_json: true))
             rescue LoadError
               %(JSON.parse(string, create_additions: false))
             end
      <<~METHOD
        def _fast_from_json(string)
          #{body}
        end
METHOD
    end

    def self.define_fast_json(receiver, name)
      cl = caller_locations(1..1).first
      method_body = public_send("#{name}_method")
      warn "Defining #{receiver}._fast_#{name} as #{method_body.inspect}"
      receiver.instance_eval method_body, cl.absolute_path, cl.lineno
    end
  end
end
