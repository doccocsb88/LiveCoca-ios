#platform :ios, '8.0'
use_frameworks!

def import_pods
#    pod 'FacebookCore', :git => 'https://github.com/facebook/facebook-sdk-swift', :branch => 'master'
#    pod 'FacebookLogin',  :git => 'https://github.com/facebook/facebook-sdk-swift', :branch => 'master'
#    pod 'FacebookShare',  :git => 'https://github.com/facebook/facebook-sdk-swift', :branch => 'master'
#    pod 'VideoCore', '~>0.3'
    pod 'lottie-ios'
    pod 'Spring', '~> 1.0'
#    pod 'LFLiveKit', '~> 2.6'
    pod 'FacebookCore', '~> 0.3'
    pod 'FacebookLogin', '~> 0.3'
    pod 'FacebookShare', '~> 0.3'

    pod 'Alamofire', '~> 4.7'
    pod 'Kingfisher', '~> 4.8'
    pod 'AlamofireObjectMapper', '~> 5.1'
    pod 'SwiftyJSON'


end
target 'coca-live'  do
    platform :ios, '8.0'
    import_pods
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
