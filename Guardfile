logger template: "\n:message"

guard 'rake', :task => 'default' do
  watch(%r{^src/.+\.(?:haml|scss|ts)$})
end

guard 'rake', :task => 'lint:run' do
  watch('bin/script.js')
end

guard 'rake', :task => 'test:run' do
  watch('bin/script.js')
  watch(%r{^spec/.+\.coffee$})
end

