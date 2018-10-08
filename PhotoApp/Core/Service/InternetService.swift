//
//  InternetService.swift
//  PhotoApp
//
//  Created by mac-089-71 on 10/8/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import Reachability

class InternetService {
    
    init() {
        reachability.whenReachable = { [weak self] _ in
            guard let `self` = self else { return }
            self.completion?(true, nil)
        }
        reachability.whenUnreachable = { [weak self] _ in
            guard let `self` = self else { return }
            self.completion?(false, InternetConnectionError.timeoutException)
        }
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func subscribe(completion: @escaping ReachabilityQuery) {
        self.completion = completion
        let (isReachable, error) = isReachability()
        completion(isReachable, error)
    }
    
    func isReachability() -> (Bool, Error?) {
        switch reachability.connection {
        case .cellular, .wifi:
            return (true, nil)
        case .none:
            return (false, InternetConnectionError.timeoutException)
        }
    }
    
    private let reachability = Reachability()!
    private var completion: ReachabilityQuery?
    
    typealias ReachabilityQuery = (Bool, Error?) -> ()
    
}
