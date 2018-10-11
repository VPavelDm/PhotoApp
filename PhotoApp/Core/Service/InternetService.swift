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
            self?.completion?(nil)
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.completion?(InternetConnectionError.timeoutException)
        }
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func subscribe(completion: @escaping ReachabilityQuery) {
        self.completion = completion
        completion(isReachability())
    }
    
    func isReachability() -> Error? {
        switch reachability.connection {
        case .cellular, .wifi:
            return nil
        case .none:
            return InternetConnectionError.timeoutException
        }
    }
    
    private let reachability = Reachability()!
    private var completion: ReachabilityQuery?
    
    typealias ReachabilityQuery = (Error?) -> ()
    
}
