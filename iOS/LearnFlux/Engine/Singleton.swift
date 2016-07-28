//
//  Singleton.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

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
    
    private var username = "admin";
    private var password = "admin";
    
    private var accessToken : String! = "";
    
    var newMessageCreated : String! = "";
    
    private var events : [Event]?
    private var threads: [Thread]?
    
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
        for each in arr{
            if each["id"] != nil && each["participants"] != nil{
                conThreads.append(Thread(dict: each))
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
    
    func saveThread(threads: Array<Dictionary<String, AnyObject>>){
        defaults.setValue(threads, forKey: cacheName.Threads)
    }
    
    func addThread(dict: Dictionary<String, AnyObject>){
        if self.threads != nil{
            threads?.append(Thread(dict: dict))
        }else{
            threads = [Thread(dict: dict)]
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
            let event = convertToEvent(dicEvent)
            if let inEvent = event{
                tempEvents.append(inEvent)
            }
        }
        return tempEvents
    }
    
    func convertToEvent(dict: Dictionary<String, AnyObject>) -> (Event?){
        if let id = dict["id"], let type = dict["type"], let timestamp = dict["timestamp"], let by = dict["created_by"]{
            if let sId = id as? String, let sType = type as? String, let dTimestamp = timestamp as? Double, let dBy = by as? Dictionary<String, AnyObject>{
                let date = NSDate(timeIntervalSince1970: dTimestamp)
                let eventBy : Event.User = (id: String(dBy["id"]!), type: String(dBy["type"]!), link: String(dBy["link"]!))
                return Event(type: sType, id: sId, time: String(date), eventBy: eventBy)
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
    
    func setPassword(string: String){
        self.password = string
    }
    
    func getPassword()->(String){
        return self.password
    }
    
    func setUsername(string: String){
        self.username = string
    }
    
    func getUsername()->(String){
        return self.username
    }
    
    func getScope()->(String){
        return self.scope
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
    
//    static let isProduction = false;
//    static let defaults = NSUserDefaults.standardUserDefaults();
//
//    static let clientId = "57453e293a603f8c168b4567_5gj7ywf0ocsoosw0sc8sgsgk8gckkc80o8co8gg00o08g88c4o";
//    static let clientSecret = "2hwdia2smbk00sko0wokowcwokswc0k448gsk0okwswcsgcw0g";
//    static let scope = "internal";
//    
//    static var username = "admin";
//    static var password = "admin";
//    
//    static var accessToken : String! = "";
//    
//    static var newMessageCreated : String! = "";
//    
//    private static var events : [Event]?
//    
//    // saveNewThreadInfo just add the newly created thread header data into the array of Threads.
//    static func saveNewThreadInfo (threadJSON JSON: AnyObject?)->Bool {
//        if (JSON == nil) { return false; }
//        if (JSON?.valueForKey("data") != nil) {
//            return saveNewThreadInfo(threadJSON: JSON!.valueForKey("data"));
//        }
//        
//        var threads = defaults.valueForKey("threads") as? Array<AnyObject?>;
//        if (threads == nil) {
//            threads = Array<AnyObject?>();
//        }
//        threads!.append(JSON);
//        defaults.setValue(threads as? AnyObject, forKey: "Threads")
//        defaults.synchronize();
//        return true;
//    }
//    
//    static func getMyEvents() -> [Event]?{
//        return events
//    }
//    
//    static func setMyEvents(arr: Array<Dictionary<String, AnyObject>>){
//        self.events = makeEventsArr(arr)
//    }
//    
//    static func makeEventsArr(rawArr : Array<Dictionary<String, AnyObject>>) -> ([Event]){
//        var tempEvents : [Event] = []
//        for dicEvent in rawArr{
//            let event = convertToEvent(dicEvent)
//            if let inEvent = event{
//                tempEvents.append(inEvent)
//            }
//        }
//        return tempEvents
//    }
//    
//    static func convertToEvent(dict: Dictionary<String, AnyObject>) -> (Event?){
//        if let id = dict["id"], let type = dict["type"], let timestamp = dict["timestamp"], let by = dict["created_by"]{
//            if let sId = id as? String, let sType = type as? String, let dTimestamp = timestamp as? Double, let dBy = by as? Dictionary<String, AnyObject>{
//                let date = NSDate(timeIntervalSince1970: dTimestamp)
//                let eventBy : Event.EventBy = (id: String(dBy["id"]!), type: String(dBy["type"]!), link: String(dBy["link"]!))
//                return Event(type: sType, id: sId, time: String(date), eventBy: eventBy)
//            }
//        }
//        return nil
//    }
}