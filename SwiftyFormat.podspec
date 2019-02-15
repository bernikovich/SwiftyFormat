Pod::Spec.new do |spec|
  spec.name          = "SwiftyFormat"
  spec.version       = "0.9.0"
  spec.summary       = "FormatterKit, but in pure Swift!"
  spec.homepage      = "https://github.com/bernikowich/SwiftyFormat"
  spec.license       = { :type => "MIT" }
  spec.author        = { "Timur Bernikovich" => "bernikowich@icloud.com" }
  spec.platform      = :ios, "10.0"
  spec.swift_version = "4.2"
  spec.framework     = "Foundation"
  spec.source        = { :git => "https://github.com/bernikowich/SwiftyFormat.git", :tag => spec.version.to_s }
  spec.source_files  = "SwiftyFormat/Classes/*.swift"
  spec.module_name   = "SwiftyFormat"
end
