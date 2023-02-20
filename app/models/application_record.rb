#
# TODO:
#
# Probably should consider swapping out the x for ROM
# https://rom-rb.org/
#
#
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  has_paper_trail ignore: [:fulltext]

  # SearchEngine implements class methods for searching
  # self.search_fulltext
  #
  extend SearchEngine

  # Parentings implements attaching and detaching resource
  # from a 'parent' - ie a model with a has_many association 
  #
  include Parentings

  # TimeParser implements class methods for parsing odd date/time formats
  # like yymmdd etc
  extend TimeParser

end
