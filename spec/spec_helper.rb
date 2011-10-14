$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'websync'
require 'fileutils'

def fixtures_folder
  File.expand_path("../fixtures", __FILE__)
end
