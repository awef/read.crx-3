guard 'rake', :task => 'default' do
  watch(%r{^src/.+\.(?:haml|scss|ts)$})

  callback('test:run')
end

guard 'rake', :task => 'lint:run' do
  watch('bin/script.js')
end

guard 'rake', :task => 'test:run' do
  watch(%r{^spec/.+\.coffee$})
end

