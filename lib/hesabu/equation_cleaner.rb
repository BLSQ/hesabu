
module Hesabu
  class EquationCleaner
    def self.clean(eq)
      clean_eq = eq.gsub(" AND ", " && ")
      clean_eq.split(/(<=|>=|!=|==|=|\*|\s)/m)
              .map { |a| a == "=" ? "==" : a }
              .join("")
    end
  end
end
