task :default => [
  "core:build",
  "core:lint",

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



file "bin/manifest.json" => "src/manifest.json" do |t|
  cp t.prerequisites[0], t.name
end

namespace :core do
  task :build => [
    "bin",

    "bin/index.html",
    "bin/style.css",
    "bin/script.js",

    "view:build",
    "lib:copy"
  ]

  task :lint do
    sh "node_modules/.bin/jshint bin/script.js"
  end

  directory "bin"

  file "bin/index.html" => "src/index.haml" do |t|
    haml t.prerequisites[0], t.name
  end

  file "bin/style.css" => FileList["src/style.scss", "src/**/*.scss"] do |t|
    sh "bundle exec scss --style compressed src/style.scss #{t.name}"
  end

  file "bin/script.js" => FileList["src/**/*.ts"] do |t|
   sh "node_modules/.bin/tsc --target ES5 --out #{t.name} src/script.ts"
  end

  namespace :view do
    files = []

    FileList["src/view/*.haml"].each do |haml_path|
      html_path = haml_path
        .gsub("src/view/", "bin/view/")
        .gsub(".haml", ".html")

      dir_path = File.dirname html_path
      directory dir_path
      files.push dir_path

      file html_path => haml_path do |t|
        haml t.prerequisites[0], t.name
      end
      files.push html_path
    end

    task :build => files
  end

  namespace :lib do
    task :copy do
      sh "./node_modules/.bin/bower install"

      {
        "bin/lib/angularjs/angular.min.js" => "bower_components/angular/angular.min.js"
      }.each do |dist, src|
        mkdir_p File.dirname(dist)
        cp src, dist
      end
    end
  end
end

namespace :test do
  task :run do
    sh "node_modules/.bin/karma start --single-run"
  end

  task :ci do
    sh "node_modules/.bin/karma start --single-run --browsers PhantomJS"
  end

  task :watch do
    sh "node_modules/.bin/karma start"
  end
end

