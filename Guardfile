logger template: "\n:message"

guard 'rake', :task => 'default' do
  watch(%r{^src/.+\.(?:haml|scss|ts)$})
  watch(%r{^spec/.+\.coffee$})
end

