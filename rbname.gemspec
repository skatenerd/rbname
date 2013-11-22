Gem::Specification.new do |s|
  s.name        = "rbname"
  s.version     = "0.0.1"
  s.date        = "2013-11-21"
  s.summary     = "CLI Find/Replace"
  s.description = "It makes stupid suggestions"
  s.authors     = ["Wai Lee Chin Feman"]
  s.email       = "skatenerd@gmail.com"
  s.files       = [
    "lib/change_prompt.rb",
    "lib/file_line.rb",
    "lib/file_line_presenter.rb",
    "lib/main.rb",
    "lib/replacement.rb",
    "lib/replacement_collection.rb"
  ]
  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'colorize'
  s.executables = ["rbname"]
  s.homepage    =
    "http://github.com/skatenerd"
  s.license       = "MIT"
end
