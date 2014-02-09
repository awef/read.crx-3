logger template: "\n:message"

guard 'rake', :task => 'default' do
  watch(%r{^src/.+\.(?:haml|scss|ts)$})
end

guard 'rake', :task => 'test:run' do
  watch(%r{^spec/.+\.coffee$})
end

