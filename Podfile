source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!

abstract_target 'MaakuTargets' do
    pod 'libcmark_gfm'

  target 'Maaku' do
    platform :ios, '9.0'
  end

  target 'Maaku-macOS' do
    platform :osx, '10.10'
  end

  target 'Maaku-watchOS' do
    platform :watchos, '2.0'
  end

  target 'Maaku-tvOS' do
    platform :tvos, '9.0'
  end

  abstract_target 'MaakuTestTargets' do
  
    pod 'Nimble'
    pod 'Quick'
    
    target 'MaakuTests' do
      platform :ios, '9.0'
    end
    
    target 'MaakuMacOSTests' do
      platform :osx, '10.11'
    end
    
    target 'Maaku-tvOSTests' do
        platform :tvos, '9.0'
    end
    
  end

end
