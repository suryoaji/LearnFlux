//
//  Request.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

enum GetImageType{
    case Me
    case Group
}

struct ConnectGroupType{
    static let join = "join"
    static let follow = "follow"
    static let unfollow = "unfollow"
}

struct Url{
    private static let base = "http://lfapp.learnflux.net"
    
    static let token = base + "/oauth/v2/token"
    static let me = base + "/v1/me/details"
    static let editMe = base + "/v1/me"
    static let messages = base + "/v1/messages"
    static let register = base + "/register"
    static let events = base + "/v1/events"
    static let groups = base + "/v1/groups"
    static let poll = base + "/v1/poll"
    static let connections = base + "/v1/me/friends"
    static let uploadImageMe = base + "/v1/me/image"
    static let availableInterests = base + "/v1/interests"
    static let notifications = base + "/v1/notifications"
    
    static func userDetail(idUser: Int) -> String{
        return base + "/v1/user/\(idUser)/details"
    }
    
    static func connectGroup(idGroup: String, type: String) -> String{
        return groups + "/\(idGroup)/connect/\(type)"
    }
    
    static func search(value: String) -> String{
        return base + "/v1/search/\(value)"
    }
    
    static func getUserDetail(id: Int) -> String{
        return base + "/v1/user/\(id)"
    }
    
    static func addConnection(id: Int) -> String{
        return base + "/v1/user/\(id)/friend"
    }
    
    static func groupEvent(idGroup idGroup: String) -> (String){
        return groups + "/\(idGroup)/events"
    }
    
    static func uploadImageGroup(idGroup idGroup: String) -> String{
        return groups + "/\(idGroup)/image"
    }
    
    static func getImage(type: GetImageType, id: String) -> String{
        let imageUrlString = base + "/v1/image"
        var typeString = ""
        switch type {
        case .Me:
            typeString = "profile"
        case .Group:
            typeString = "group"
        }
        return imageUrlString + "?key=\(typeString)/\(id)"
    }
    
    static func getBaseUrl() -> String{
        return base
    }
}