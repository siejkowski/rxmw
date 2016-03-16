import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let disposeBag = DisposeBag()
    private let scheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
    private let observable = Observable<Int>.create { observer in
        print("create1: \(NSThread.currentThread())")
        observer.onNext(1)
        observer.onNext(2)
        observer.onNext(3)
        observer.onNext(4)
        observer.onNext(5)
        observer.onCompleted()
        print("create2: \(NSThread.currentThread())")
        return NopDisposable.instance
    }
    //    Observable<Int>.interval(1,
    //            scheduler: SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
    //            scheduler: MainScheduler.instance
    //    )
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let queue = NSOperationQueue()
        queue.addOperationWithBlock {
            
            self.observable
                //        .subscribeOn(MainScheduler.instance)
                //        .subscribeOn(scheduler)
                .observeOn(self.scheduler)
                .map {
                    _ in
                    print("map1: \(NSThread.currentThread())")
                }
                //        .observeOn(MainScheduler.instance)
                .map {
                    _ in
                    print("map2: \(NSThread.currentThread())")
                }
                //        .observeOn(scheduler)
                //        .subscribeOn(MainScheduler.instance)
                .subscribeNext {
                    _ in
                    print("subscribe: \(NSThread.currentThread())")
                }
                .addDisposableTo(self.disposeBag)
        }
        
        return true
    }


}

