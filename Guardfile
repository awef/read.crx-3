logger template: "\n:message"

guard 'rake', :task => 'default' do
  watch(%r{^src/.+\.(?:haml|scss|ts)$})
end

guard 'rake', :task => 'core:test' do
  watch(%r{^spec/.+\.coffee$})
end

