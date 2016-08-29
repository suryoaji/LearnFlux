//
//  Request.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

struct Url{
    private static let base = "http://lfapp.learnflux.net"
    
    static let token = base + "/oauth/v2/token"
    static let me = base + "/v1/me"
    static let messages = base + "/v1/messages"
    static let register = base + "/register"
    static let events = base + "/v1/events"
    static let groups = base + "/v1/groups"
    static let poll = base + "/v1/poll"
    
    static func groupEvent(idGroup idGroup: String) -> (String){
        return groups + "/\(idGroup)/events"
    }
}