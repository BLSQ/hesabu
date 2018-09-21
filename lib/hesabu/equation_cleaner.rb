
module Hesabu
  class EquationCleaner
    def self.clean(eq)
      return eq if !eq.include?("AND") && !eq.include?("=") && !eq.include?("OR")
      clean_eq = eq.gsub(" AND ", " && ")
      clean_eq = clean_eq.gsub(" OR ", " || ")
      clean_eq.split(/(<=|>=|!=|==|=|\*|\s)/m)
              .map { |a| a == "=" ? "==" : a }
              .join("")
    end
  end
end
