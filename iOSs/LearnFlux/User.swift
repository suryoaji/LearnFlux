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
    var selfLink : String?
    var friendsLink : String?
    var firstName: String?
    var lastName: String?
    var picture: String?
    var photo: UIImage?
    var email: String?
    var mutualFriend: [Int]?
    var friends: [Int]?
    var interests: [String]?
    var location: String?
    var work: String?
    var childrens : [User]?
    var groups : [Group]?
    
    init (dict : AnyObject?, imageHasLoaded: ((type: Int, id: String, status: Bool) -> Void)? = nil)  {
        guard let data = dict else { return }
        if let s = data[keyCacheMe.id] as? Int { self.userId = s }
        if let s = data[keyCacheMe.type] as? String { self.type = s }
        if let s = data[keyCacheMe.firstName] as? String { self.firstName = s }
        if let s = data[keyCacheMe.email] as? String{ self.email = s }
        if let s = data[keyCacheMe.lastName] as? String{ self.lastName = s }
        if let s = data[keyCacheMe.interests] as? Array<String>{ self.interests = s }
        if let s = data[keyCacheMe.from] as? String { self.location = s }
        if let s = data[keyCacheMe.work] as? String { self.work = s }
        if let s = data[keyCacheMe.links] as? Dictionary<String, AnyObject>{
            if let selfLinks = s["self"]{
                if let selfLink = selfLinks["href"] as? String{
                    self.selfLink = updateLinks(selfLink)
                }
            }
            if let friendsLinks = s[keyCacheMe.friends]{
                if let friendsLink = friendsLinks["href"] as? String{
                    self.friendsLink = updateLinks(friendsLink)
                }
            }
            if let photoLinks = s[keyCacheMe.linkPhoto]{
                if let photoLink = photoLinks["href"] as? String{
                    self.picture = updateLinks(photoLink); loadImage(imageHasLoaded)
                }
            }
        }
        if let s = data[keyCacheMe.mutualFriends]{
            self.mutualFriend = arrFriends(s)
        }else{
            self.mutualFriend = Array(count: Int(arc4random_uniform(25)), repeatedValue: -1)
        }
    }
    
    func update(dict: AnyObject?, imageHasLoaded: ((type: Int, id: String, status: Bool) -> Void)? = nil){
        guard let data = dict else{ return }
        if let s = data[keyCacheMe.embedded] as? Dictionary<String, AnyObject>{
            if let arrDictChildrens = s[keyCacheMe.children] as? Array<Dictionary<String, AnyObject>>{
                var childrens = [User]()
                for each in arrDictChildrens{
                    childrens.append(User(dict: each, imageHasLoaded: imageHasLoaded))
                }
                self.childrens = childrens
            }
            if let arrDictGroups = s[keyCacheMe.groups] as? Array<Dictionary<String, AnyObject>>{
                var groups = [Group]()
                for each in arrDictGroups{
                    groups.append(Group(dict: each, imageHasLoaded: imageHasLoaded))
                }
                self.groups = groups
            }
        }
        if let s = data[keyCacheMe.mutualFriends] as? Array<Dictionary<String, AnyObject>>{
            self.mutualFriend = s.filter({ $0[keyCacheMe.id] as! Int != self.userId! }).map({ $0[keyCacheMe.id] as! Int })
        }
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
    
    func getOrganizations() -> [Group]{
        guard let groups = groups else{
            return []
        }
        return groups.filter({ $0.type == "organization" })
    }
    
    func getFriends() -> (mine: [Int], notMine: [Int]){
        guard let friends = friends else{
            return (mine: [], notMine: [])
        }
        let myFriends = Engine.clientData.getMyConnection().friends.map({ $0.userId! })
        return (mine: Array(Set(friends).intersect(Set(myFriends))), notMine: Array(Set(friends).subtract(Set(myFriends))))
    }
    
    func loadImage(callback: ((type: Int, id: String, status: Bool) -> Void)?){
        if let id = self.userId{
            if id != Engine.clientData.cacheSelfId(){
                if let link = self.picture{
                    Engine.getImageIndividual(urlIndividual: link){image in
                        self.photo = image
                        self.picture = nil
                        if image != nil{
                            if callback != nil { callback!(type: 1, id: "\(self.userId!)", status: true) }
                        }else{
                            if callback != nil { callback!(type: 1, id: "\(self.userId!)", status: false) }
                        }
                    }
                }
            }else{
                self.photo = Engine.clientData.photo
                self.picture = nil
            }
        }
    }
    
    func loadDetail(){
        guard self.userId != nil else{
            print("cannot load friends \(self.firstName!) detail, caused by userId is nil")
            return
        }
        Engine.requestUserDetail(idUser: self.userId!){ status, JSON in
            if status == .Success && JSON != nil{
                let data = JSON as! Dictionary<String, AnyObject>
                if let s = data[keyCacheMe.mutualFriends]{
                    self.mutualFriend = self.arrFriends(s)
                }
            }
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
    
    func updateLinks(href: String) -> String{
        var href = href
        href = href.stringByReplacingOccurrencesOfString("/api", withString: "")
        href = href.stringByReplacingOccurrencesOfString("?id=", withString: "?key=")
        return href
    }
    
}






























