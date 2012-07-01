require 'frank-cucumber'

ENV['TESTING_ENV'] ||= 'command_line'
environment = ENV['TESTING_ENV']

if environment == 'command_line'
 BASE_DIR = "/Users/verdywid/Library/Developer/Xcode/DerivedData/WakeMe-dassetyeejokcretkmyxgmxgcstj/"
 APP_BUNDLE_PATH =  "#{BASE_DIR}Build/Products/Debug-iphonesimulator/WakeMeFrankified.app"
 APP_DIR = "#{BASE_DIR}Build/Intermediates/WakeMe.build/Debug-iphonesimulator/WakeMeFrankified.build"
elsif environment == 'jenkins'
 BASE_DIR = "/var/jenkins/.jenkins/jobs/WakeMe Project UI Tests/workspace/"
 APP_BUNDLE_PATH =  "#{BASE_DIR}build/Debug-iphonesimulator/WakeMeFrankified.app"
 APP_DIR = "#{BASE_DIR}build/WakeMe.build/Debug-iphonesimulator/WakeMeFrankified.build"
end

#### Common ####
SDK_DIR = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.1.sdk/"
APP_BINARY = "#{APP_BUNDLE_PATH}/WakeMeFrankified"
USER_DIR = "iPhone Simulator/User"
PREF_DIR = "#{USER_DIR}/Library/Preferences"
DYLD_ROOT_DIR = "/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib"

