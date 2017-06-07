# coding: utf-8
Pod::Spec.new do |s|

  s.name         = "JudSDK"

  s.version      = "1.1.0"

  s.summary      = "JudSDK iOS Source ."

  s.description  = <<-DESC
                   A framework for building Mobile cross-platform UI
                   DESC

  s.homepage     = "https://treasureu.github.io/"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
           JUD-INC copyright
    LICENSE
  }
  s.authors      = { "chengajianfeng"      => "673302055@163.com"
                   }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source =  { :path => '.' }
  s.source_files = 'JudSDK/Sources/**/*.{h,m,mm,c}'
  s.resources = 'JudSDK/Resources/main.js', 'JudSDK/Resources/jud_load_error@3x.png'

  s.requires_arc = true
  s.prefix_header_file = 'JudSDK/Sources/Supporting Files/JudSDK-Prefix.pch'

#  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) DEBUG=1' }

  s.xcconfig = { "OTHER_LINK_FLAG" => '$(inherited) -ObjC'}

  s.user_target_xcconfig  = { 'FRAMEWORK_SEARCH_PATHS' => "'$(PODS_ROOT)/JudSDK'" }

  s.frameworks = 'CoreMedia','MediaPlayer','AVFoundation','AVKit','JavaScriptCore', 'GLKit'

  s.dependency 'SocketRocket'
  s.libraries = "stdc++"

end
