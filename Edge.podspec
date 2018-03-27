Pod::Spec.new do |spec|
  spec.name     = 'Edge'
  spec.version  = '1.3.0'
  spec.summary  = 'A modern HTTP network library. Built on top of URLSession.'
  spec.homepage = 'https://github.com/therapychat/Edge'
  spec.license  = { type: 'Apache License, Version 2.0', file: 'LICENSE' }
  spec.authors  = { 'Sergio Fernandez' => 'fdz.sergio@gmail.com' }
  spec.social_media_url = 'https://twitter.com/fdzsergio'

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'

  spec.swift_version  = '4.0'
  spec.source_files   = 'Source/*.swift'
  spec.source         = { :git => "https://github.com/therapychat/Edge.git", :tag => spec.version.to_s }

end
