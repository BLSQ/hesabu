require "bigdecimal"
module Hesabu
  module Types
    MAXDECIMAL = Float::DIG + 1

    def self.as_numeric!(value)
        numeric = as_numeric(value)
        return numeric if numeric
        raise "Not a numeric : '#{value}' (#{value.class.name})" 
    end

    def self.as_numeric(value)
        return value if value.is_a?(::Numeric)
        value = value.str if value.is_a?(::Parslet::Slice)
        if value.is_a?(::String)
            number = value[/\A-?\d*\.?\d+\z/]
            if number             
                if number.include?('.') 
                    return ::BigDecimal.new(number, MAXDECIMAL)
                else 
                    return number.to_i 
                end
            end
        end
    end

    def self.as_bigdecimal(number)
        return ::BigDecimal.new(number, MAXDECIMAL)
    end
  end
end