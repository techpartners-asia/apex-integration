import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
 override func applicationShouldTerminateAfterLastWindowClosed( sender: NSApplication) > Bool {
 return true
 }

 override func applicationSupportsSecureRestorableState( app: NSApplication) > Bool {
 return true
 }
}
