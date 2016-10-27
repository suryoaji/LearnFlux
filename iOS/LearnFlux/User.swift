//
//  User.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 8/10/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class User {
    
    var userId : Int?
    var type : String?
    var link : String?
    var firstName: String?
    var lastName: String?
    var picture: String?
    var photo: UIImage?
    var email: String?
    var mutualFriend: Int?
    var friends: [Int]?
    
    init (userId: Int?, type: String?, link: String?) {
        self.userId = userId;
        self.type = type;
        self.link = link;
    }
    
    init (dict : AnyObject?)  {
        guard let data = dict else { return }
        if let s = data["id"] as? Int { self.userId = s }
        if let s = data["type"] as? String { self.type = s }
        if let s = data["link"] as? String { self.link = s }
        if let s = data["first_name"] as? String { self.firstName = s }
        if let s = data["profile_picture"] as? String{ self.picture = s; loadImage() }
        if let s = data["email"] as? String{ self.email = s }
        if let s = data["last_name"] as? String{ self.lastName = s }
        
        self.mutualFriend = Int(arc4random_uniform(25))
        updateFromCacheMe()
    }
    
    func updateFromCacheMe(){
        guard let cacheFriend = (Engine.clientData.cacheSelfFriends().filter({ $0[keyCacheMe.id] as! Int == self.userId! })).first else{
            return
        }
        self.lastName = cacheFriend["last_name"] as? String
        self.email = cacheFriend["email"] as? String
        self.friends = arrFriends(cacheFriend["friends"])
    }
    
    func arrFriends(friends: AnyObject?) -> Array<Int>{
        guard let friends = friends else{
            return []
        }
        if let friends = friends as? Dictionary<String, Dictionary<String, AnyObject>>{
            return friends.map({ $0.1["id"] as! Int })
        }else if let friends = friends as? Array<Dictionary<String, AnyObject>>{
            return friends.map({ $0["id"] as! Int })
        }
        return []
    }
    
    func loadImage(){
        Engine.getImageIndividual(id: String(self.userId!)){ image in
            self.photo = image
            self.picture = nil
        }
    }
    
    static func convertFromArr (arr : AnyObject?) -> [User]? {
        guard let data = arr as? arrType else { return nil; }
        var result = [User]();
        for el in data {
            guard let p = User.convertFromDict(el) else { continue; }
            result.append(p);
        }
        return result;
    }
    
    static func convertFromDict (dict : AnyObject?) -> User? {
        guard let data = dict as? dictType else { return nil; }
        return User(dict: data);
    }
    
}