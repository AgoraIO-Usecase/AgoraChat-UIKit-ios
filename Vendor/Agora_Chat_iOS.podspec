# Local specification for the SDK snapshot supplied with this migration.
Pod::Spec.new do |s|
  s.name = 'Agora_Chat_iOS'
  s.version = '5.2.0'
  s.summary = 'Agora Chat SDK snapshot for SDK 5 migration'
  s.homepage = 'https://github.com/AgoraIO/AgoraChat_iOS'
  s.license = { :type => 'Commercial', :text => 'Agora Chat SDK; subject to the Agora SDK license.' }
  s.author = { 'Agora' => 'support@agora.io' }
  s.source = { :git => 'https://github.com/AgoraIO/AgoraChat_iOS.git' }
  s.ios.deployment_target = '15.0'
  s.vendored_frameworks = 'AgoraChat.xcframework'
  s.dependency 'AgoraInfra_iOS', '~> 1.3.0'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
end
