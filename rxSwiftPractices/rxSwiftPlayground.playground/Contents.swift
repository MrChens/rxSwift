import RxSwift

example(of: "creating observales") {
    let mostPopular: Observable<String> = Observable<String>.just(episodeV)
    let originalTrilogy = Observable.of(episodeIV, episodeV, episodeVI)
    let prequelTrilogy = Observable.of([episodeI, episodeII,episodeIII])
    let sequelTrilogy = Observable.from([episodeVII, episodeVIII, episodeIX])
}

example(of: "subscribe") {
    let observable = Observable.of(episodeIV, episodeV, episodeVI)
    
//    observable.subscribe(observable)
    observable.subscribe { event in
//        print(event)
        print(event.element ?? event)
    }
    print("---")
//    observable.subscribe { element in
//        print(element)
//    }
    observable.subscribe(onNext: { element in
        print(element)
    })
    print("---")
    observable.subscribe { element in
        print(element)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("on completed")
    } onDisposed: {
        print("on disposed")
    }
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe { element in
        print(element)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }
}

example(of: "never") {
    let observale = Observable<Any>.never()
    observale.subscribe { element in
        print(element)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }
}

example(of: "dispose") {
    let mostPopular = Observable.of(episodeV, episodeIV, episodeVI)
    
    let suscription = mostPopular.subscribe { event in
        print(event.element ?? event)
    }
    suscription.dispose()
}

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()
    
    Observable.of(episodeVII, episodeI, rogueOne)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "create") {
    enum Droid: Error {
        case oU812
    }
    
    let disposeBag = DisposeBag()
    Observable<String>.create { observer in
        
        observer.onNext("R2-D2")
//        observer.onError(Droid.oU812)
        observer.onNext("C-3PO")
        observer.onNext("K-")
        observer.onCompleted()
//        Disposables.create {
//            print("dd disposables")
//        }
        return Disposables.create()
    }
    .subscribe { event in
        print(event)
    } onError: {
        print("Error:", $0)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("Disposed")
    }
    .disposed(by: disposeBag)
}
//MARK: Single one next event or error event
// Completable completed event or error event
// Maybe One next, completed, or error event

//example(of: "Single") {
//    let disposeBag = DisposeBag()
//    
//    enum FileReadError: Error {
//        case fileNotFound, unreadable, encodingFailed
//    }
//    
//    func loadText(from filename: String) -> Single<String> {
//        return Single.create { single in
//            let disposable = Disposables.create()
//            
//            guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
//                single(.error(FileReadError.fileNotFound))
//                return disposable
//            }
//            
//            guard let data = FileManager.default.contents(atPath: path) else {
//                single(.error(FileReadError.unreadable))
//                return disposable
//            }
//            
//            guard let contents = String(data: data, encoding: .utf8) else {
//                single(.error(FileReadError.encodingFailed))
//                return disposable
//            }
//            
//            single(.success(contents))
//            return disposable
//        }
//    }
//    
//    loadText(from: "ANewHope")
//        .subscribe { event in
//            print(event)
//            switch event {
//            case .success(let string):
//                print(string)
//            case .error(let error):
//                print(error)
//            }
//        }
//        .disposed(by: disposeBag)
//    
//    
//}

//Observable can be subscribed to
//Observer Add new elements

//MARK: SUBJECT
//PublishSubject
//BehaviorSubject
//ReplaySubject
//Variable

//MARK: PUBLISHSUBJECT
//Starts empty
//Emits new next events to new subscribers

example(of: "PublishSubject") {
    let quotes = PublishSubject<String>()
    
    quotes.onNext(itsNotMyFault)
    
    let subscriptionOne = quotes
        .subscribe { event in
//            print(label: "1)", event: event)
            print("1)", event)
        }
    quotes.on(.next(doOrDoNot))
    
    let subscriptionTwo = quotes
        .subscribe { event in
            print("2)", event)
        }
    
    quotes.onNext(lackOfFaith)
    
    subscriptionOne.dispose()

    quotes.on(.next(eyesCanDeceive))
    
    quotes.onCompleted()
    
    let suscriptionThree = quotes
        .subscribe { event in
            print("3)", event)
        }
    
    quotes.on(.next(stayOnTarget))
//    subscriptionTwo.dispose()
    subscriptionTwo.dispose()
    suscriptionThree.dispose()
}

//MARK: BEHAVIORSUBJECT
//Starts with initial vale
//Replays initial/latest value to new subscribers

example(of: "BehaviorSubject") {
    enum Quote: Error {
    case neverSaidthat
    }
    
    let disposeBag = DisposeBag()
    
//    let qutes = BehaviorSubject(value: iAmYourFather)
    let qutes = BehaviorSubject<String>(value: iAmYourFather)
    
    let subscriptionOne = qutes
        .subscribe { event in
            print("1)", event)
        }
//        .subscribe { event in
//            print("1)", event)
//        }
//        .subscribe {
//            print("1)", $0.element ?? $0)
//        }
    
    qutes.onError(Quote.neverSaidthat)
    
    qutes
        .subscribe {
            print("2)", $0.element ?? $0)
        }
    .disposed(by: disposeBag)

}
//MARK: REPLAYSUBJECT
//Starts empty, with a buffer size
//Replays buffer to new suscribers
example(of: "ReplaySubject") {
    let disposeBag = DisposeBag()
    
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    
    subject.onNext("useTheForce")
    
    subject
        .subscribe {
            print("1)", $0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("theForceIsStrong")
    
    subject
        .subscribe {
            print("2)", $0)
        }
        .disposed(by: disposeBag)
}
 
//MARK: VARIABLE
//Wraps a BehaviorSubject
//Starts with initial value
//Replays initial/latest value to new subscribers
//Guaranteed not to fail
//Automatically completes
//Stateful

//example(of: "Variable") {
//    enum MyError: Error {
//    case anError
//    }
//    let disposeBag = DisposeBag()
//
//    let variable = Variable(mayTheForceBeWithYou)
//
//    print(variable.value)
//    variable.asObservable()
//        .subscribe {
//            print("1)", $0)
//        }
//        .disposed(by: disposeBag)
//
//    variable.value = mayThe4thBeWithYou
//
////    variable.value = MyError.anError
////    variable.asObservable().onError(MyError.anError)
////    variable.asObservable().onCompleted()
//}
