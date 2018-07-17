
module Hesabu
  class EquationCleaner
    def self.clean(eq)
      return eq if !eq.include?("AND") && !eq.include?("=")
      clean_eq = eq.gsub(" AND ", " && ")
      clean_eq.split(/(<=|>=|!=|==|=|\*|\s)/m)
              .map { |a| a == "=" ? "==" : a }
              .join("")
    end
  end
end
