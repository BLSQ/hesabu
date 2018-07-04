module Hesabu
  class Parser < Parslet::Parser
    def cts(atom_arg)
      atom_arg >> space?
    end

    # simple things
    rule(:lparen)             { str("(") >> space? }
    rule(:rparen)             { str(")") >> space? }
    rule(:comma)              { str(",") >> space? }
    rule(:space)              { match["\s"] | match["\t"] | match["\n"] }
    rule(:spaces)             { space.repeat }
    rule(:space?)             { spaces.maybe }

    rule(:nonquote)   { str("'").absnt? >> any }
    rule(:quote)      { str("'") }
    rule(:string)     { quote >> nonquote.as(:char).repeat(1).as(:str) >> quote >> space? }

    rule(:identifier) do
      cts((match["a-zA-Z"] >> match["a-zA-Z0-9_"].repeat).as(:identifier))
    end

    rule(:separator) { str(";") }

    rule(:digit) { match["0-9"] }

    rule(:integer) do
      cts((str("-").maybe >> match["1-9"] >> digit.repeat).as(:integer) | str("0").as(:integer))
    end

    rule(:float) do
      cts((str("-").maybe >> digit.repeat(1) >> str(".") >> digit.repeat(1)).as(:float))
    end

    # arithmetic

    rule(:expression)         { addition | comparison | variable | pexpression }
    rule(:pexpression)        { lparen >> expression >> rparen }

    rule(:variable)           { identifier.as(:variable) } # gets simplified into a value, an "identifier" does not
    rule(:sum_op)             { match("[+-]") >> space? }
    rule(:mul_op)             { match("[*/]") >> space? }
    rule(:comparison_op)      { (str("<=") | str(">=") | str("==") | str("!=") | str("<") | str("=") | str(">") | str("AND")) >> space? }

    rule(:atom) {  string | pexpression | float | integer | fcall.as(:fcall) | variable }

    rule(:comparison) do
      atom.as(:left) >> comparison_op.as(:op) >> atom.as(:right)
    end

    rule(:addition) {
      (multiplication.as(:left) >> (sum_op.as(:op) >> multiplication.as(:right)).repeat(1)) |
      multiplication 
    }
    
    rule(:multiplication) { 
      atom.as(:left) >> (mul_op.as(:op) >> atom.as(:right)).repeat(1) |
      atom }

    # lists
    rule(:varlist)    { expression >> (comma >> expression).repeat }
    rule(:pvarlist)   { (lparen >> varlist.repeat >> rparen).as(:plist) }

    # functions
    rule(:fcall)        { identifier.as(:name) >> pvarlist.as(:varlist) }

    # root
    rule(:command) do
      addition |        comparison | 
      atom

    end
    rule(:commands) { commands.repeat }
    root :command
  end
end
