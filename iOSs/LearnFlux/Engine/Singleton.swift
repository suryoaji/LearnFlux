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
    static let friends = "friends"
    static let friendRequest = "friend_request"
    static let friendRequested = "friend_requested"
    static let from = "location"
    static let work = "work"
    static let editFirstname = "firstname"
    static let editLastname = "lastname"
    static let children = "children"
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
    }
    
    private let isProduction = false
    
    private let clientId = "580db5c83a603f82528b4567_ahqk6r8gni8088ock80wkkok4wk0ooc8g4s0kkg880soow4k8";
    private let clientSecret = "5d13jtr20js4wcw0488888ck0k0c0sk0kos8c08wo8wsgog8ss";
    private let scope = "internal";
    
    private var refreshToken : String! = ""
    
    private var accessToken : String! = "";
    
    var newMessageCreated : String! = "";
    
    private var childrens: [User]?
    
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
    
    func getMyConnection() -> ([User]?){
        return self.connection
    }
    
    func setMyConnections(arr: Array<Dictionary<String, AnyObject>>){
        self.connection = makeConnectionsArr(arr)
    }
    
    func addToConnection(user: User){
        if connection == nil{
            connection = [user]
        }else{
            connection?.append(user)
        }
    }
    
    func makeConnectionsArr(rawArr: Array<Dictionary<String, AnyObject>>) -> ([User]){
        var tempUsers : [User] = []
        for dicUser in rawArr{
            let user = User(dict: dicUser)
            tempUsers.append(user)
        }
        return tempUsers
    }
    
    func updateSpecificEventsByIdGroup(idGroup : String, events: [Event]?){
        let indexSpecificEvents = specificEvents.indexOf({ $0.id == idGroup })
        var conSpecificEvents = specificEvents[indexSpecificEvents!]
        specificEvents.removeAtIndex(indexSpecificEvents!)
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
        self.specificEvents.insert(conSpecificEvents, atIndex: indexSpecificEvents!)
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
    
    func getFilteredGroup(filterBy: FilterGroupType) -> ([Group]){
        let filteredGroups = getGroups()?.filter({ $0.type == "group" })
        if filteredGroups != nil{
            var newFilteredGroups : [Group] = []
            for group in filteredGroups! where getMyThreads() != nil{
                if !(getMyThreads()!.filter({ $0.id == group.thread?.id })).isEmpty{
                    newFilteredGroups.append(group)
                }
            }
            return newFilteredGroups
        }
        return []
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
    
    func setMyChildrens(childrens: [User]){
        self.childrens = childrens
    }
    
    func getMyChildrens() -> [User]{
        return self.childrens ?? []
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
        guard let id = dict["id"] where (id as? String) != nil else{
            return nil
        }
        let sId = id as! String
        if self.threads != nil{
            let thread = self.threads!.filter({ $0.id == sId })
            if thread.isEmpty{
                addThread(dict)
            }
        }else{
            addThread(dict)
        }
        return self.threads!.filter({ $0.id == sId }).first!
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
    
    func getGroups(filter: GroupType = .All) -> ([Group]?){
        var filtered : [Group]? = [Group]();
        if (filter == .All) {
            if let data = groups { filtered = data; }
        }
        else {
            guard let data = groups else { return nil; }
            for el in data {
                if (filter == .Organisation && el.type == "organization") { filtered!.append (el); }
                if (filter == .InterestGroup && el.type == "group") { filtered!.append (el); }
            }
        }
        return filtered;
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
    
    func cacheSelfChildrens() -> Array<Dictionary<String, AnyObject>>{
        return cacheMe()![keyCacheMe.children] != nil ? cacheMe()![keyCacheMe.children] as! Array<Dictionary<String, AnyObject>> : []
    }
    
    func cacheSelfFriends() -> Array<Dictionary<String, AnyObject>>{
        return cacheMe()![keyCacheMe.friends] != nil ? cacheMe()![keyCacheMe.friends] as! Array<Dictionary<String, AnyObject>> : []
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
    
    func cacheSelfFriendRequest() -> Array<Dictionary<String, AnyObject>>{
        return arrayFromDict(cacheMe()![keyCacheMe.friendRequest]!)
    }
    
    func cacheSelfFriendRequested() -> Array<Dictionary<String, AnyObject>>{
        return arrayFromDict(cacheMe()![keyCacheMe.friendRequested]!)
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