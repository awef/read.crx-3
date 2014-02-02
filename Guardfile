guard 'rake', :task => 'default' do
  watch(%r{^src/.+\.(?:haml|scss|ts)$})

  callback('test:run')
end

guard 'rake', :task => 'test:run' do
  watch(%r{^spec/.+\.coffee$})
end

