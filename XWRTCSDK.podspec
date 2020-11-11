#
# Be sure to run `pod lib lint XWRTCSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XWRTCSDK'
  s.version          = '0.1.0'
  s.summary          = '欣网视频客服'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '欣网视频客服sdk，iOS客户端，包含客服端和用户端'

  s.homepage         = 'https://github.com/gaoleyu/XWRTCSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '330944735@qq.com' => '330944735@qq.com' }
  s.source           = { :git => 'https://github.com/gaoleyu/XWRTCSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  #代码地址
    s.source_files = 'SPKF/**/*.{h,m}',' SPKF/**/**/*.{h,m}','SPKF/**/**/**/*.{h,m}','SPKF/**/**/**/**/*.{h,m}'

  #build setting 设置
  s.user_target_xcconfig = {'OTHER_LDFLAGS' => ['-ObjC','-all_load']}

    #图片地址
     s.resource_bundles = {
       'XWRTCImage' => ['SPKF/livechatimages/*.{png,gif,mp3}']
     }

    #framework 地址
    #s.vendored_framework = 'SPKF/AgoraRtcKit/*.framework'
  #公开的头文件
    s.public_header_files = 'SPKF/SPKFCommond/Third/XWAPPID.h','SPKF/MainManager/XWRTCManager.h'

  #pch 文件地址
  #s.prefix_header_file = 'SPKF/**/*.pch'

  #依赖的系统文件
    s.libraries = 'z'

  #依赖的三方库
     
     s.dependency 'SDWebImage', '~>5.8.1'
     s.dependency 'AFNetworking', '~>3.2.0'
     s.dependency 'MBProgressHUD', '~>1.2.0'
     s.dependency 'Masonry', '~>1.1.0'
     s.dependency 'MJRefresh', '~>3.5.0'
     
     s.dependency 'AgoraRtcEngine_iOS_Crypto', '~> 3.1.1'
     
  #所有的依赖库
  #s.frameworks = 'UIKit','SDWebImage','AFNetworking','MBProgressHUD','MJRefresh'
end
