# Modify the STDLIB Date class to include our holidays features
require 'holidays/core_extensions/date'
class Date
  include Holidays::CoreExtensions::Date
end
