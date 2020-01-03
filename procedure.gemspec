require File.expand_path('../lib/procedure/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  s.name        = 'procedure'
  s.version     = ::Procedure::Version
  s.date        = '2019-11-21'
  s.summary     = "Mariage of policy object and interactor patterns"
  s.description = "Mariage of policy object and interactor patterns"
  s.authors     = ["Paweł Dąbrowski"]
  s.email       = 'dziamber@gmail.com'
  s.files       = Dir['lib/**/*.rb', 'spec/helper.rb']
  s.homepage    =
    'http://github.com/pdabrowski6/procedure'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.3.0'
end
