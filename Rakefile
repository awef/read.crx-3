task :default => [
  "core:build",
  "core:lint",
  "core:test",

  "bin/manifest.json"
]

task :clean do
  rm_rf "bin"
end

task :watch do
  sh "bundle exec guard --notify false"
end

def haml(src, output)
  sh "bundle exec haml -q #{src} #{output}"
end



rule %r{bin/.+\.js} => "%{^bin/lib/,lib/}X.js" do |t|
  cp t.prerequisites[0], t.name
end

file "bin/manifest.json" => "src/manifest.json" do |t|
  cp t.prerequisites[0], t.name
end

namespace :core do
  task :build => [
    "bin",

    "bin/lib/jquery",
    "bin/lib/jquery/jquery.min.js",

    "bin/lib/angularjs",
    "bin/lib/angularjs/angular.min.js",
    "bin/lib/angularjs/angular-route.min.js",

    "bin/index.html",
    "bin/style.css",
    "bin/script.js",

    "view:build"
  ]

  task :lint do
    sh "node_modules/.bin/jshint bin/script.js"
  end

  task :test do
    sh "node_modules/.bin/karma start --single-run"
  end

  directory "bin"
  directory "bin/lib/angularjs"
  directory "bin/lib/jquery"

  file "bin/index.html" => "src/index.haml" do |t|
    haml(t.prerequisites[0], t.name)
  end

  file "bin/style.css" => FileList["src/style.scss", "src/**/*.scss"] do |t|
    sh "bundle exec scss --style compressed src/style.scss #{t.name}"
  end

  file "bin/script.js" => FileList["src/**/*.ts"] do |t|
   sh "node_modules/.bin/tsc --target ES5 --out #{t.name} src/script.ts"
  end

  namespace :view do
    files = ["debug/view"]

    directory "debug/view"

    FileList["src/view/*.haml"].each do |haml_path|
      html_path = haml_path
        .gsub("src/view/", "bin/view/")
        .gsub(".haml", ".html")

      directory_path = html_path.gsub(%r"/[^/]+$", "")
      directory directory_path
      files.push(directory_path)

      file html_path => haml_path do |t|
        haml(t.prerequisites[0], t.name)
      end
      files.push(html_path)
    end

    task :build => files
  end
end

namespace :lib do
  task :dl_angular, :version do |t, args|
    files = ["angular", "angular-route"]

    files.each do |filename|
      sh "wget -O lib/angularjs/#{filename}.min.js https://ajax.googleapis.com/ajax/libs/angularjs/#{args[:version]}/#{filename}.min.js"
    end
  end
end

