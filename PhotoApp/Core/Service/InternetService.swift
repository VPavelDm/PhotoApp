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
            self.isReachability = true
            for (index, completion) in self.completions.enumerated() {
                completion(nil)
                let _ = self.completions.remove(at: index)
            }
        }
        reachability.whenUnreachable = { [weak self] _ in
            guard let `self` = self else { return }
            self.isReachability = false
            for completion in self.completions {
                completion(InternetConnectionError.timeoutException)
            }
        }
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func isReachability(completion: @escaping ReachabilityQuery) {
        if let isReachability = isReachability {
            if isReachability == false {
                completions.append(completion)
                completion(InternetConnectionError.timeoutException)
            } else {
                completion(nil)
            }
        } else {
            completions.append(completion)
        }
    }
    
    private var isReachability: Bool?
    private let reachability = Reachability()!
    private var completions: [ReachabilityQuery] = []
    
    typealias ReachabilityQuery = (Error?) -> ()
    
}
