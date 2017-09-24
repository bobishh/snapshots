$:.unshift(File.expand_path('../lib', __FILE__))

require_relative './lib/snapshots.rb'

run Snapshots::App
