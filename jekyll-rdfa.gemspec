Gem::Specification.new do |s|
  s.name        = 'jekyll-rdfa'
  s.version     = '0.0.0'
  s.date        = '2015-10-22'
  s.summary     = 'A Jekyll generator for RDFa.'
  s.authors     = ["Eric Rochester", "Purdom Lindblad"]
  s.email       = 'erochest@virginia.edu'
  s.files       = ['lib/jekyll-rdfa.rb']
  s.homepage    = 'http://www.ericrochester.com/jekyll-rdfa/'
  s.license     = 'Apache-2'
  s.description = %{A Jekyll generator to scan for RDFa-encoded data
  in posts and dumps the entire graph out to a JSON-LD and Turtle
  file.}
end
