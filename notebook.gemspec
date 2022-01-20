Gem::Specification.new do |s|
  s.name                  = 'notebook'
  s.version               = '0.3.2'
  s.summary               = "Ruby .ipynb Support"
  s.description           = "Ruby tools for Jupyter Notebooks"
  s.authors               = ["newms"]
  s.email                 = ''
  s.files                 = ['lib/notebook.rb', 'lib/notebook/notebookcell.rb',
                             'lib/notebook/formatter.rb', 'lib/notebook/loader.rb',
                             'lib/notebook/nbtools.rb']
  s.homepage              = 'https://github.com/newman174/ruby_notebook'
  s.license               = 'None'
  s.required_ruby_version = '>= 3.0.0'
end
