source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13'
use_frameworks!

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
	installer.aggregate_targets.each do |target|
		target.xcconfigs.each do |variant, xcconfig|
			xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
		end
	end
end

target 'Bluetooth' do
	pod 'SnapKit'
	pod 'Resolver'
end
