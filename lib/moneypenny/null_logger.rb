class NullLogger
  %w( debug notice warn ).each do |method_name|
    define_method( method_name ) {}
  end
end
