//
//  Singleton.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

enum GroupType {
    case Organisation
    case Group
    case InterestGroup
    case All
}

enum FilterGroupType{
    case ByInterestGroup
    case None
}

struct keyCacheMe{
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let id = "id"
    static let email = "email"
    static let interests = "interests"
    static let from = "location"
    static let work = "work"
    static let editFirstname = "firstname"
    static let editLastname = "lastname"
    static let children = "children"
    static let links = "_links"
    static let embedded = "_embedded"
    static let friends = "friends"
    static let type = "type"
    static let linkPhoto = "profile_picture"
    static let mutualFriends = "mutual"
}

struct keyCacheFriends{
    static let friends = "friends"
    static let pending = "pending"
    static let request = "requested"
}

typealias EventsByIdGroup = (id: String, events: [Event])

class Data : NSObject {
    class var sharedInstance : Data{
        struct Singleton{
            static let instance = Data()
        }
        return Singleton.instance
    }
    
    var photo = UIImage(named: "photo-container.png")!
    
    let defaults = NSUserDefaults.standardUserDefaults();
    
    private struct cacheName{
        static let Threads = "threads"
        static let LastSync = "lastSync"
        static let Me = "me"
        static let Notification = "notifs"
        static let Friends = "friend"
    }
    
    private let isProduction = false
    
    private let clientId = "580db5c83a603f82528b4567_ahqk6r8gni8088ock80wkkok4wk0ooc8g4s0kkg880soow4k8";
    private let clientSecret = "5d13jtr20js4wcw0488888ck0k0c0sk0kos8c08wo8wsgog8ss";
    private let scope = "internal";
    
    private var refreshToken : String! = ""
    
    private var accessToken : String! = "";
    
    var newMessageCreated : String! = "";
    
    private var pendingConnections : [User] = []
    
    private var requestedConnections : [User] = []
    
    private var childrens : [User] = []
    
    private var connection: [User]?{
        didSet{
            if let index = connection?.indexOf({ $0.userId == (cacheMe()!["id"] as! Int) }){
                connection?.removeAtIndex(index)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ConnectionsUpdateNotification", object: nil)
            checkAllDataReady()
        }
    }
    private var events : [Event]?{
        didSet{
            checkAllDataReady()
        }
    }
    private var threads: [Thread]?{
        didSet{
            if threads != nil{
                let sortedThreads = threads!.sort({ $0.lastUpdated > $1.lastUpdated })
                threads = sortedThreads
                NSNotificationCenter.defaultCenter().postNotificationName("ThreadsUpdateNotification", object: nil)
            }
            checkAllDataReady()
        }
    }
    private var groups: [Group]?{
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("GroupsUpdateNotification", object: nil)
            checkAllDataReady()
        }
    }
    private var specificEvents: Array<EventsByIdGroup> = []{
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("SpecificEventsUpdateNotification", object: nil)
        }
    }
    
    override init(){
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sortThreads), name: "sortThreads", object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func checkAllDataReady(){
        if threads != nil && groups != nil && events != nil && connection != nil{
            if groups!.filter({ $0.participants != nil && !$0.participants!.isEmpty }).count == groups!.count{
                NSNotificationCenter.defaultCenter().postNotificationName("dataSingletonReady", object: nil)
            }
        }
    }
    
    func getMyConnection() -> (friends: [User], pending: [User], requested: [User]){
        return (friends: self.connection!, pending: self.pendingConnections, requested: self.requestedConnections)
    }
    
    func setMyConnections(arrFriends: Array<Dictionary<String, AnyObject>>, _ arrPendingFriends: Array<Dictionary<String, AnyObject>>, _ arrRequestedFriends: Array<Dictionary<String, AnyObject>>){
        self.connection = makeConnectionsArr(arrFriends)
        self.pendingConnections = makeConnectionsArr(arrPendingFriends)
        
        if !arrRequestedFriends.isEmpty{
            let arrFilteredRequestedFriends = arrRequestedFriends.filter({ dict -> Bool in
                if dict["id"] as! Int == cacheSelfId(){
                    return false
                }
                if arrFriends.contains({ ($0["id"] as! Int) == dict["id"] as! Int }){
                    return false
                }
                return true
            })
            let arrFiltered = arrFilteredRequestedFriends.reduce(Array<Dictionary<String, AnyObject>>(), combine: { a, b in
                if a.contains({ $0["id"] as! Int == b["id"] as! Int }){
                    return a
                }else{
                    return a + [b]
                }
            })
            self.requestedConnections = makeConnectionsArr(arrFiltered)
        }else{
            self.requestedConnections = []
        }
        
        loadAllPendingFriendsDetail()
    }
    
    func loadAllPendingFriendsDetail(){
        for each in self.pendingConnections{
            each.loadDetail()
        }
    }
    
    func addToConnection(user: User){
        if connection == nil{
            connection = [user]
        }else{
            connection?.append(user)
        }
    }
    
    func addToRequestedConnection(user: User){
        if !self.requestedConnections.contains({ $0.userId == user.userId }){
            self.requestedConnections.append(user)
        }
    }
    
    func removePendingFriends(index: Int){
        self.pendingConnections.removeAtIndex(index)
    }
    
    func makeConnectionsArr(rawArr: Array<Dictionary<String, AnyObject>>) -> ([User]){
        var tempUsers : [User] = []
        for dicUser in rawArr{
            if dicUser["id"] as! Int == cacheSelfId(){
                continue
            }
            let user = User(dict: dicUser)
            tempUsers.append(user)
        }
        return tempUsers
    }
    
    func updateSpecificEventsByIdGroup(idGroup : String, events: [Event]?){
        guard let indexSpecificEvents = specificEvents.indexOf({ $0.id == idGroup }) else{
            return
        }
        var conSpecificEvents = specificEvents[indexSpecificEvents]
        specificEvents.removeAtIndex(indexSpecificEvents)
        if let events = events{
            for event in events{
                if let indexEvent = conSpecificEvents.events.indexOf({ $0.id == event.id }){
                    conSpecificEvents.events.removeAtIndex(indexEvent)
                    conSpecificEvents.events.insert(event, atIndex: indexEvent)
                }else{
                    conSpecificEvents.events.append(event)
                }
            }
        }
        self.specificEvents.insert(conSpecificEvents, atIndex: indexSpecificEvents)
    }
    
    func getSpecificEventsByIdGroup(idGroup: String) -> [Event]?{
        let filteredSpecificEvents =  self.specificEvents.filter({ $0.id == idGroup })
        if !filteredSpecificEvents.isEmpty{
            return filteredSpecificEvents.first!.events
        }
        return nil
    }
    
    func addEmptySpecificEvents(idGroup: String){
        self.specificEvents.append((id: idGroup, events: []))
    }
    
    func addSpecificEvents(idGroup: String, arrDictEvents: Array<Dictionary<String, AnyObject>>){
        var conEvents : [Event] = []
        for each in arrDictEvents{
            if let event = Event.convertToEvent(each){
                conEvents.append(event)
            }
        }
        self.specificEvents.append((id: idGroup, events: conEvents))
    }
    
    func sortThreads(notification: NSNotification){
        if let con = threads{
            self.threads = nil
            self.threads = con
        }
    }
    
    func updateGroup(group: Group){
        let index = groups!.indexOf({ $0.id == group.id })!
        groups!.removeAtIndex(index)
        groups!.insert(group, atIndex: index)
    }
    
    func addNewGroup(dict: Dictionary<String, AnyObject>){
        if Group.convertFromDict(dict) != nil{
            if self.groups != nil{
                groups!.append(Group.convertFromDict(dict)!)
            }else{
                groups = [Group.convertFromDict(dict)!]
            }
        }
    }
    
    func idGroupByIdThread(idThread: String)->(String?){
        if let groups = groups{
            for each in groups{
                if each.threadId != nil{
                    if each.threadId! == idThread{
                        return each.id
                    }
                }
            }
        }
        return nil
    }
    
    func saveAllThreads(arr: Array<Dictionary<String, AnyObject>>, lastSync: String){
        defaults.setValue(arr, forKey: cacheName.Threads)
        defaults.setValue(lastSync, forKey: cacheName.LastSync)
        defaults.synchronize()
    }
    
    func getMyThreads()->[Thread]?{
        return self.threads
    }
    
    func setThreads(arr: Array<Dictionary<String, AnyObject>>){
        var conThreads : [Thread] = []
        for i in 0..<arr.count{
            if arr[i]["id"] != nil && arr[i]["participants"] != nil{
                conThreads.append(Thread(dict: arr[i], index: i))
            }
        }
//        self.threads = !conThreads.isEmpty ? conThreads : nil
        self.threads = conThreads
    }
    
    func addNewThread(dict: Dictionary<String, AnyObject>){
        addThread(dict)
        addThreadToCache(dict)
    }
    
    func addThreadToCache(dict: Dictionary<String, AnyObject>){
        if var cacheThreads = self.cacheThreads(){
            cacheThreads.append(dict)
            saveThread(cacheThreads)
        }else{
            saveThread([dict])
        }
    }
    
    func deleteThread(id: String){
        deleteThreadObject(id)
        deleteThreadFromCache(id)
    }
    
    func deleteThreadObject(id: String){
        if let index = threads!.indexOf({ $0.id == id }){
            threads!.removeAtIndex(index)
        }
    }
    
    func deleteThreadFromCache(id: String){
        if var cache = cacheThreads(){
            if let index = cache.indexOf({ $0["id"] != nil && ($0["id"]! as! String) == id }){
                cache.removeAtIndex(index)
                saveThread(cache)
            }
        }
    }
    
    func deleteThreads(idThreads: Array<String>){
        guard let cache = self.cacheThreads() else{
            return
        }
        var conCache = cache
        for id in idThreads{
            if let index = conCache.indexOf( { $0["id"] as! String == id } ){
                conCache.removeAtIndex(index)
            }
        }
        self.saveThread(conCache)
        self.setThreads(conCache)
    }
    
    func setMyChildrens(){
        self.childrens = cacheEmbeddedChildrens().map({ User(dict: $0) })
    }
    
    func getMyChildrens() -> [User]{
        return self.childrens
    }
    
    func saveThread(threads: Array<Dictionary<String, AnyObject>>){
        defaults.setValue(threads, forKey: cacheName.Threads)
    }
    
    func addThread(dict: Dictionary<String, AnyObject>){
        if self.threads != nil{
            threads?.append(Thread(dict: dict, isNew: true))
        }else{
            threads = [Thread(dict: dict, isNew: true)]
        }
    }
    
    func getThread(dict: Dictionary<String, AnyObject>) -> (Thread)?{
        guard let id = dict["id"] as? String else{
            return nil
        }
        guard var participants = dict["participants"] as? Array<Dictionary<String, AnyObject>> else{
            return nil
        }
        
        for i in 0..<participants.count{
            if participants[i][keyCacheMe.id] == nil{
                if (participants[i][keyCacheMe.firstName] as! String).lowercaseString == cacheSelfFirstname().lowercaseString{
                    participants[i]["id"] = cacheSelfId()
                }else if let index = connection!.indexOf({ $0.firstName?.lowercaseString == (participants[i][keyCacheMe.firstName] as! String).lowercaseString}){
                    participants[i]["id"] = connection![index].userId
                }
            }
        }
        var newDict = dict
        newDict["participants"] = participants
        
        if self.threads != nil{
            let thread = self.threads!.filter({ $0.id == id })
            if thread.isEmpty{
                addThread(newDict)
            }
        }else{
            addThread(newDict)
        }
        return self.threads!.filter({ $0.id == id }).first!
    }
    
    func getMyEvents()->[Event]?{
        return events
    }
    
    func setMyEvents(arr: Array<Dictionary<String, AnyObject>>){
        self.events = makeEventsArr(arr)
    }

    func makeEventsArr(rawArr : Array<Dictionary<String, AnyObject>>) -> ([Event]){
        var tempEvents : [Event] = []
        for dicEvent in rawArr{
            let event = Event.convertToEvent(dicEvent)
            if let inEvent = event{
                tempEvents.append(inEvent)
            }
        }
        return tempEvents
    }

    func setGroups(arr: arrType){
        self.groups = Group.convertFromArr(arr);
    }
    
    func getGroups(filter: GroupType = .All) -> ([Group]){
        switch filter {
        case .All:
            return self.groups != nil ? self.groups! : []
        case .Organisation:
            return self.groups != nil ? self.groups!.filter({ $0.type.lowercaseString == "organization" }) : []
        case .InterestGroup:
            return self.groups != nil ? self.groups!.filter({ $0.type.lowercaseString == "group" }) : []
        default:
            return []
        }
    }
    
    func setCurrentOrg(arr: arrType) {
        
    }
    
    
    func convertToGroup(dict: Dictionary<String, AnyObject>) -> (Group?){
        if let id = dict["id"], let type = dict["type"], let name = dict["name"], let thread = dict["message"]{
            if let sId = id as? String, let sType = type as? String, let sName = name as? String, let dThread = thread as? Dictionary<String, AnyObject>{
                let threadRef = Thread(dict: dThread);
                return Group(type: sType, id: sId, name: sName, thread: threadRef)
            }
        }
        return nil
    }
    
    func cacheThreads() -> (Array<Dictionary<String, AnyObject>>)?{
        if let cacheThreads = self.defaults.valueForKey(cacheName.Threads){
            return cacheThreads as? Array<Dictionary<String, AnyObject>>
        }
        print("Data : *Cache Threads is nil")
        return nil
    }
    
    func cacheLastSyncThreads() -> (Double)?{
        if let cacheLastSync = self.defaults.valueForKey(cacheName.LastSync){
            return Double(cacheLastSync as! String)!
        }
        print("Data : *Cache LastSync is nil")
        return nil
    }
    
    func cacheMe() -> Dictionary<String, AnyObject>?{
        if let cacheMe = self.defaults.valueForKey(cacheName.Me){
            return cacheMe as? Dictionary<String, AnyObject>
        }
        print("Data : *Cache Me is nil")
        return nil
    }
    
    func cacheNotifications() -> Array<Dictionary<String, AnyObject>>{
        if let cacheNotifications = self.defaults.valueForKey(cacheName.Notification){
            return cacheNotifications as! Array<Dictionary<String, AnyObject>>
        }
        return []
    }
    
    func saveNotifications(notifs: Array<Dictionary<String, AnyObject>>){
        defaults.setValue(notifs, forKey: cacheName.Notification)
    }
    
    func updateNotifications(appendNotifs: Array<Dictionary<String, AnyObject>>){
        var cache = cacheNotifications()
        cache += appendNotifs
        saveNotifications(cache)
    }
    
    func updateMe(me: Dictionary<String, AnyObject>){
        var cache = cacheMe()!
        for each in me{
            switch each.0 {
            case keyCacheMe.editFirstname:
                cache[keyCacheMe.firstName] = each.1
            case keyCacheMe.editLastname:
                cache[keyCacheMe.lastName] = each.1
            default:
                cache[each.0] = each.1
            }
        }
        saveMe(cache)
    }
    
    func cacheSelfFirstname() -> String{
        return cacheMe()![keyCacheMe.firstName] as! String
    }
    
    func cacheFullname() -> String{
        return "\(cacheMe()![keyCacheMe.firstName]!) \(cacheMe()![keyCacheMe.lastName]!)"
    }
    
    func cacheSelfId() -> Int{
        return cacheMe()![keyCacheMe.id] as! Int
    }
    
    func cacheSelfEmail() -> String{
        return cacheMe()![keyCacheMe.email] as! String
    }
    
    func cacheSelfInterests() -> Array<String>{
        return cacheMe()![keyCacheMe.interests] != nil ? cacheMe()![keyCacheMe.interests] as! Array<String> : []
    }
    
    func cacheSelfWork() -> String{
        return cacheMe()![keyCacheMe.work] != nil ? cacheMe()![keyCacheMe.work] as! String : ""
    }
    
    func cacheSelfFrom() -> String{
        return cacheMe()![keyCacheMe.from] != nil ? cacheMe()![keyCacheMe.from] as! String : ""
    }
    
    func cacheLinks() -> Dictionary<String, AnyObject>{
        return cacheMe()![keyCacheMe.links] != nil ? cacheMe()![keyCacheMe.links] as! Dictionary<String, AnyObject> : [:]
    }
    
    func cacheLinkFriends() -> String?{
        guard !cacheLinks().isEmpty else{
            return nil
        }
        guard let linksFriend = cacheLinks()[keyCacheMe.friends] as? Dictionary<String, AnyObject> else{
            return nil
        }
        return linksFriend["href"] != nil ? linksFriend["href"] as? String : nil
    }
    
    func cacheLinkPhoto() -> String?{
        guard !cacheLinks().isEmpty else{
            return nil
        }
        guard let linksPhoto = cacheLinks()[keyCacheMe.linkPhoto] as? Dictionary<String, AnyObject> else{
            return nil
        }
        return linksPhoto["href"] != nil ? linksPhoto["href"] as? String : nil
    }
    
    func cacheEmbedded() -> Dictionary<String, AnyObject>{
        return cacheMe()![keyCacheMe.embedded] != nil ? cacheMe()![keyCacheMe.embedded] as! Dictionary<String, AnyObject> : [:]
    }
    
    func cacheEmbeddedChildrens() -> Array<Dictionary<String, AnyObject>>{
        guard !cacheEmbedded().isEmpty else{
            return []
        }
        guard let arrChildrens = cacheEmbedded()["children"] as? Array<Dictionary<String, AnyObject>> else{
            return []
        }
        return arrChildrens
    }
    
    func arrayFromDict(dict: AnyObject) -> Array<Dictionary<String, AnyObject>>{
        if let dict = dict as? Dictionary<String, Dictionary<String, AnyObject>>{
            return [Dictionary<String, AnyObject>](dict.values)
        }else if let arr = dict as? Array<Dictionary<String, AnyObject>>{
            return arr
        }else{
            return []
        }
    }
    
    func saveMe(me: AnyObject){
        defaults.setValue(me, forKey: cacheName.Me)
    }
    
    func saveFriends(friends: AnyObject){
        defaults.setValue(friends, forKey: cacheName.Friends)
    }
    
    func clearCacheThreads(){
        self.defaults.removeObjectForKey(cacheName.Threads)
    }
    
    func clearCacheLastSync(){
        self.defaults.removeObjectForKey(cacheName.LastSync)
    }
    
    func setAccessToken(string: String){
        self.accessToken = string
    }
    
    func getAccessToken()->(String){
        return self.accessToken
    }

    func getScope()->(String){
        return self.scope
    }
    
    func getRefreshToken() -> String{
        return self.refreshToken
    }
    
    func setRefreshToken(token: String){
        self.refreshToken = token
    }
    
    func getClientSecret()->(String){
        return self.clientSecret
    }
    
    func getClientID()->(String){
        return self.clientId
    }
    
    func getIsProduction()->(Bool){
        return self.isProduction
    }
}