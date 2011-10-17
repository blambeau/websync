$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'websync'
require 'fileutils'
require 'tmpdir'
require 'fixtures'
#Grit.debug = true

def capture_io
  stdout, stderr = $stdout, $stderr
  out, err = StringIO.new, StringIO.new
  $stdout, $stderr = out, err
  yield
  [out.string, err.string]
ensure
  $stdout, $stderr = stdout, stderr
end
