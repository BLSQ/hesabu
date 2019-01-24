require_relative "./hesabu/version"

require_relative "./hesabu/errors"
require_relative "./hesabu/types/numeric"

require_relative "./hesabu/multi_json"
require_relative "./hesabu/solver"


module Hesabu

  case RUBY_PLATFORM
  when /darwin/
    HESABUCLI = File.expand_path("../bin/hesabucli-mac", File.dirname(__FILE__))
    :mac
  when /cygwin|mswin|mingw|bccwin|wince|emx/
    raise UnsupportedPlatform.new("Windows is not (yet) supported")
  else
    HESABUCLI = File.expand_path("../bin/hesabucli", File.dirname(__FILE__))
  end


  unless File.file?(HESABUCLI)
    warn <<WARNING
********************
No hesabucli found!
  -> #{HESABUCLI}
********************
WARNING
  end
end
