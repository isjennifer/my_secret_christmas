import Flutter
import UIKit
import FacebookCore

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Facebook SDK 초기화
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Flutter 플러그인 등록
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // URL을 통해 Facebook SDK와 상호작용을 처리합니다.
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
            // Facebook URL인 경우
        if url.scheme?.hasPrefix("fb") == true {
            return ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[.sourceApplication] as? String,
                annotation: options[.annotation]
            )
        }
        
        // Facebook URL이 아닌 경우 Flutter(app_links)로 처리 위임
        return super.application(app, open: url, options: options)
    }
}
