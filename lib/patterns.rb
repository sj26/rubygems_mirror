module Patterns
  # From rubygems.org
  SPECIAL_CHARACTERS = ".-_"
  ALLOWED_CHARACTERS = "A-Za-z0-9#{Regexp.escape(SPECIAL_CHARACTERS)}"

  SLUG = /[#{ALLOWED_CHARACTERS}]+/
  NONGREEDY_SLUG = /[#{ALLOWED_CHARACTERS}]+?/

  NAME = /\A[#{ALLOWED_CHARACTERS}]+\Z/
  VERSION = /\A#{Gem::Version::VERSION_PATTERN}\z/
  PLATFORM = NAME
end
