//
//  Request.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Url : NSObject {
    
    static let base = "http://lfapp.learnflux.net";
    
    static let token = base + "/oauth/v2/token";
    static let me = base + "/v1/me";
    
}