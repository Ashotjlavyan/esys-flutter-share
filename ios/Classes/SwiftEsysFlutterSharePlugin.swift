import Flutter
import UIKit

public class SwiftEsysFlutterSharePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "channel:github.com/orgs/esysberlin/esys-flutter-share", binaryMessenger: registrar.messenger())
        let instance = SwiftEsysFlutterSharePlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "text"){
            self.text(arguments: call.arguments, result: result)
        }
        if(call.method == "file"){
            self.file(arguments: call.arguments, result: result)
        }
        if(call.method == "files"){
            self.files(arguments: call.arguments, result: result)
        }
    }
    
    func text(arguments:Any?, result: @escaping FlutterResult) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let text:String = argsMap.value(forKey: "text") as! String
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if let error = error {
                result(FlutterError(code: String((error as NSError).code),
                          message: (error as NSError).domain,
                          details: error.localizedDescription))
            } else if (completed) {
                // user shared an item
                result(0);
            } else {
                // user cancelled
                result(-1);
            }
        }
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
    
    func file(arguments:Any?, result: @escaping FlutterResult) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let name:String = argsMap.value(forKey: "name") as! String
        let text:String = argsMap.value(forKey: "text") as! String
        
        // load the file
        let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
        let contentUri = NSURL(fileURLWithPath: docsPath).appendingPathComponent(name)
        
        // prepare sctivity items
        var activityItems:[Any] = [contentUri!];
        if(!text.isEmpty){
            // add optional text
            activityItems.append(text);
        }
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if let error = error {
                result(FlutterError(code: String((error as NSError).code),
                          message: (error as NSError).domain,
                          details: error.localizedDescription))
            } else if (completed) {
                // user shared an item
                result(0);
            } else {
                // user cancelled
                result(-1);
            }
        }
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
    
    func files(arguments:Any?, result: @escaping FlutterResult) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let names:[String] = argsMap.value(forKey: "names") as! [String]
        let text:String = argsMap.value(forKey: "text") as! String
        
        // prepare sctivity items
        var activityItems:[Any] = [];
        
        // load the files
        for name in names {
            let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
            activityItems.append(NSURL(fileURLWithPath: docsPath).appendingPathComponent(name)!);
        }
        
        if(!text.isEmpty){
            // add optional text
            activityItems.append(text);
        }
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if let error = error {
                result(FlutterError(code: String((error as NSError).code),
                          message: (error as NSError).domain,
                          details: error.localizedDescription))
            } else if (completed) {
                // user shared an item
                result(0);
            } else {
                // user cancelled
                result(-1);
            }
        }
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
}
