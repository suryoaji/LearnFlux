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



class Data : NSObject {
    class var sharedInstance : Data{
        struct Singleton{
            static let instance = Data()
        }
        return Singleton.instance
    }
    
    let defaults = NSUserDefaults.standardUserDefaults();
    
    private struct cacheName{
        static let Threads = "threads"
        static let LastSync = "lastSync"
        static let Me = "me"
    }
    
    private let isProduction = false
    
    private let clientId = "57453e293a603f8c168b4567_5gj7ywf0ocsoosw0sc8sgsgk8gckkc80o8co8gg00o08g88c4o";
    private let clientSecret = "2hwdia2smbk00sko0wokowcwokswc0k448gsk0okwswcsgcw0g";
    private let scope = "internal";
    
    private var refreshToken : String! = ""
    
    private var accessToken : String! = "";
    
    var newMessageCreated : String! = "";
    
    private var events : [Event]?
    private var threads: [Thread]?{
        didSet{
            if threads != nil{
                let sortedThreads = threads!.sort({ $0.lastUpdated > $1.lastUpdated })
                threads = sortedThreads
            }
        }
    }
    private var groups: [Group]?
    
    override init(){
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sortThreads), name: "sortThreads", object: nil)
    }
    
    func sortThreads(notification: NSNotification){
        if let con = threads{
            self.threads = nil
            self.threads = con
        }
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
        self.threads = !conThreads.isEmpty ? conThreads : nil
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
    
    func clearCacheThreads(){
        self.defaults.removeObjectForKey(cacheName.Threads)
    }
    
    func clearCacheLastSync(){
        self.defaults.removeObjectForKey(cacheName.LastSync)
    }
    
    func saveMe(me: AnyObject){
        defaults.setValue(me, forKey: cacheName.Me)
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