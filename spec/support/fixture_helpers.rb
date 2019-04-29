require "rubygems"
require 'json'

def fixture_file_path(filename)
  Rails.root.join("spec/fixtures/#{filename}").to_s
end

def read_fixture_file(filename)
  file = File.read fixture_file_path(filename)
  data = JSON.parse(file)
end

def yaml_fixture_file(filename)
  YAML.load_file(fixture_file_path(filename))
end