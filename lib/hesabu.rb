require_relative "./hesabu/version"

require_relative "./hesabu/errors"
require_relative "./hesabu/types/numeric"

require_relative "./hesabu/multi_json"
require_relative "./hesabu/solver"


module Hesabu
  HESABUCLI = File.expand_path("../bin/hesabucli", File.dirname(__FILE__))
  puts "************** HESABU cli location : " + HESABUCLI
end
