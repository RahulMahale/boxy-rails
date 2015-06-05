require 'chefspec'
require 'chefspec/berkshelf'
require 'active_support/core_ext/string'

def read_fixture_file(name)
  spec_root = File.expand_path("../", __FILE__)
  File.read(File.join(spec_root, 'fixtures', name))
end
