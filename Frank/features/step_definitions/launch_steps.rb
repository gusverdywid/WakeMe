require 'fileutils'

ACCESIBILITY_PLIST   = "com.apple.Accessibility.plist"
ACCESIBILITY_CONTENT = <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>ApplicationAccessibilityEnabled</key>
<true/>
</dict>
</plist>
PLIST

Before do
  # check that pwd contains the "build" dir as we are creating
  # items relative to it.
  #Dir["build"].length.should == 1

  pwd     = "#{Dir.pwd}"

  # make sure we do start with a clean environment
  FileUtils.remove_dir("#{pwd}/#{USER_DIR}",true)

  prefdir = "#{pwd}/#{PREF_DIR}"
  FileUtils.mkdir_p prefdir

  File.open("#{pwd}/#{PREF_DIR}/#{ACCESIBILITY_PLIST}", 'w') do |f|
    f <<ACCESIBILITY_CONTENT
  end

#  ENV['SDKROOT']               = "#{SDK_DIR}"
#  ENV['DYLD_ROOT_PATH']        = "#{SDK_DIR}"
#  ENV['IPHONE_SIMULATOR_ROOT'] = "#{SDK_DIR}"
#  ENV['TEMP_FILES_DIR']        = "#{APP_DIR}"
#  ENV['CFFIXED_USER_HOME']     = "#{pwd}/#{USER_DIR}"
end

After do
  frankly_exit
end

def launch_app_headless
  @apppid = fork do
    exec(APP_BINARY, "-RegisterForSystemEvents")
  end
  wait_for_frank_to_come_up
end

def frankly_exit
  frank_server.send_get( 'exit' )
  # calling exit in the app will not return any response
  # so we simply catch the error caused by exiting.
  #rescue FrankNetworkError
  #  return true
  #rescue Errno::ECONNREFUSED
  #  return true
  #rescue EOFError
  #  return true
  rescue RuntimeError
end

Given /^I launch the headless app$/ do
  launch_app_headless
end

def app_path
  ENV['APP_BUNDLE_PATH'] || (defined?(APP_BUNDLE_PATH) && APP_BUNDLE_PATH)
end

Given /^I launch the app$/ do
  # latest sdk and iphone by default
  launch_app app_path
end

Given /^I launch the app using iOS (\d\.\d)$/ do |sdk|
  # You can grab a list of the installed SDK with sim_launcher
  # > run sim_launcher from the command line
  # > open a browser to http://localhost:8881/showsdks
  # > use one of the sdk you see in parenthesis (e.g. 4.2)
  launch_app app_path, sdk
end

Given /^I launch the app using iOS (\d\.\d) and the (iphone|ipad) simulator$/ do |sdk, version|
  launch_app app_path, sdk, version
end
