#
# Be sure to run `pod lib lint FTSegmentedContainerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'FTSegmentedContainerView'
    s.version          = '0.3.0'
    s.summary          = 'Segmented container view with progress bars.'
    
    
    s.homepage         = 'https://github.com/farabis4m/FTSegmentedContainerView'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Thahir Maheen' => 'thahir@farabi.ae' }
    s.source           = { :git => 'https://github.com/farabis4m/FTSegmentedContainerView.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.source_files = 'FTSegmentedContainerView/**/*'
end

