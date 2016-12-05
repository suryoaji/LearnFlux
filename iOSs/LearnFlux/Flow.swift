//
//  FlowOrganiser.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 8/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

enum FlowName{
    case NewGroup
    case NewThread
    case NewInterestGroup
    case NewEvent
    case NewOrganization
    case NewProject
    case None
}

class Flow {
    static var sharedInstance = Flow();
    
    private var data = Dictionary<String, AnyObject>();
    private var name : FlowName!
    private var callback : ((Dictionary<String, AnyObject>?)->Void)?;
    private var active : Bool = false;
    private var vcStacks = [UIViewController]()
    
    func clear () {
        data.removeAll();
        callback = nil;
        active = false;
        name = .None;
        vcStacks = [];
    }
    
    func begin (flowName: FlowName) {
        clear()
        self.name = flowName
        active = true
    }
    
    func activeFlow () -> FlowName? {
        if active { return name; }
        else { return nil; }
    }
    
    func isActive() -> (Bool){
        return self.active
    }
    
    func pushVc (viewController: UIViewController) { vcStacks.append(viewController); }
    func popVc (viewController: UIViewController) {
        if let index = vcStacks.indexOf(viewController){
            vcStacks.removeAtIndex(index)
        }
    }
    
    func removeFlowVc (navController : UINavigationController, exceptVc: [UIViewController]? = nil, removeLastViewController: Bool = false) {
        var arrIndex : [Int] = []
        for vc in vcStacks{
            if removeLastViewController{
                if navController.viewControllers.last! == vc{
                    continue
                }
            }
            if let index = navController.viewControllers.indexOf(vc){
                if let exceptVc = exceptVc where exceptVc.contains(vc){
                    arrIndex = []
                    continue
                }
                arrIndex.append(index)
            }
        }
        if !arrIndex.isEmpty{
            arrIndex = arrIndex.sort({ $0 > $1 })
            navController.viewControllers.removeRange(arrIndex.last!...arrIndex.first!)
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
    func end (target: UIViewController? = nil, andClear : Bool = false) {
        if let callback = callback{
            callback(data)
        }
        if let target = target where target.navigationController != nil{
            self.removeFlowVc(target.navigationController!)
        }
        if andClear { self.clear() }
    }
    
    func getViewControllers() -> ([UIViewController]){
        return self.vcStacks
    }
}