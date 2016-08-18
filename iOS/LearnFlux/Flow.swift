//
//  FlowOrganiser.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 8/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Flow {
    static var sharedInstance = Flow();
    
    private var data = Dictionary<String, AnyObject>();
    private var name : String = "";
    private var callback : ((Dictionary<String, AnyObject>?)->Void)?;
    private var active : Bool = false;
    private var vcStacks = [UIViewController]();
    
    func clear () {
        data.removeAll();
        callback = nil;
        active = false;
        name = "";
        vcStacks = [];
    }
    
    func begin (flowName: String) {
        clear();
        self.name = flowName;
        active = true;
    }
    
    func activeFlow () -> String? {
        if active { return name; }
        else { return nil; }
    }
    
    func pushVc (viewController: UIViewController) { vcStacks.append(viewController); }
    func popVc (viewController: UIViewController) {
        var i = vcStacks.count;
        while (i >= 0) {
            i -= 1;
            let vc = vcStacks[i];
            if vc == viewController {
                vcStacks.removeAtIndex(i);
                break;
            }
        }
    }
    
    func removeFlowVc (navController : UINavigationController, exceptVc: [UIViewController]? = nil) {
        for vc in vcStacks {
            var vcNav = navController.viewControllers;
            var i = vcNav.count;
            while (i >= 0) {
                i -= 1;
                let vc2 = vcNav[i];
                if vc == vc2 {
                    var isRemove = true;
                    if let eVc = exceptVc {
                        for vc3 in eVc {
                            if vc == vc3 { isRemove = false; }
                        }
                    }
                    if (isRemove) { vcNav.removeAtIndex(i); }
                    break;
                }
            }
        }
    }
    
    func add (dict dict: Dictionary<String, AnyObject>) {
        for (key, value) in dict {
            data[key] = value;
        }
    }
    
    func get (key key : String) -> AnyObject? { return data[key]; }
    func set (key key : String, value: AnyObject?) { data[key] = value; }
    func setCallback (callback: ((Dictionary<String, AnyObject>?)->Void)) { self.callback = callback; }
    func end (andClear andClear : Bool = false) {
        if (callback != nil) {
            callback! (data);
            if (andClear) { self.clear(); }
        }
    }
    
}