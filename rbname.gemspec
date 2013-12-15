Gem::Specification.new do |s|
  s.name        = "rbname"
  s.version     = "0.0.4"
  s.date        = "2013-12-14"
  s.summary     = "CLI Find/Replace"
  s.description = "It makes stupid suggestions"
  s.authors     = ["Wai Lee Chin Feman"]
  s.email       = "skatenerd@gmail.com"
  s.files       = [
    "lib/change_prompt.rb",
    "lib/extensions/array.rb",
    "lib/extensions/object.rb",
    "lib/extensions/string.rb",
    "lib/file_line.rb",
    "lib/file_line_presenter.rb",
    "lib/main.rb",
    "lib/replacement.rb",
    "lib/replacement/score.rb",
    "lib/replacement_collection.rb",
    "lib/vim_edit.rb"
  ]
  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'colorize'
  s.executables = ["rbname"]
  s.homepage    =
    "http://github.com/skatenerd"
  s.license       = "MIT"
end
