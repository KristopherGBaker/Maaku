Pod::Spec.new do |s|

  s.name         = "Maaku"
  s.version      = "0.7.0"
  s.summary      = "Swift cmark-gfm wrapper with a Swift friendly representation of the AST"

  s.description  = <<-DESC
                   The Maaku framework provides a Swift wrapper around cmark-gfm with the addition
                   of a Swift friendly representation of the AST.
                   DESC

  s.homepage     = "https://github.com/KristopherGBaker/Maaku"
  s.license      = "MIT"
  s.author             = { "Kristopher Baker" => "Kristopher Baker" }
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => "https://github.com/KristopherGBaker/Maaku.git", :tag => "#{s.version}" }
  s.requires_arc = true
  s.default_subspec = 'Core'
  
  s.subspec 'CMark' do |core|
      core.source_files = "Sources/Maaku/CMark/**/*.swift"
      core.dependency 'libcmark_gfm', '~> 0.29'
  end
  
  s.subspec 'Core' do |md|
      md.source_files = "Sources/Maaku/Core/**/*.swift"
      md.dependency 'Maaku/CMark'
  end
  
  s.subspec 'Plugins' do |plugins|
      plugins.source_files = "Sources/Maaku/Plugins/**/*.swift"
      plugins.dependency 'Maaku/Core'
  end

end
