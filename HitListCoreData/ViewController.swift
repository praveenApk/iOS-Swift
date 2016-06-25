//
//  ViewController.swift
//  HitListCoreData
//
//  Created by PraveenApk on 25/06/16.
//  Copyright © 2016 PraveenApk. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var hitListTableView: UITableView!
    var names =  [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hitListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.hitListTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            names = results as! [NSManagedObject]
        } catch let error as NSError{
            print(error)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.hitListTableView.dequeueReusableCellWithIdentifier("Cell")
        let person = names[indexPath.row]
        cell?.textLabel?.text = person.valueForKey("name") as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            self.deleteName(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Update Name", message: "Please enter a new name", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .Default) { (action: UIAlertAction) in
            
            let textField = alert.textFields?.first
            self.updateName((textField?.text)!, index: indexPath.row)
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
                self.hitListTableView.reloadData()
                }, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) in
            
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.text = self.names[indexPath.row].valueForKey("name") as? String
        }
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func AddName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name", message: "Add a New Name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) in
            let textField = alert.textFields?.first
            self.saveName((textField?.text)!)
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { 
                self.hitListTableView.reloadData()
                }, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) in
            
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func saveName(name: String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        names.append(person)
        
        do {
          try managedContext.save()
        } catch let error as NSError{
            print(error.userInfo)
        }
    }
    
    func deleteName(index: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(names[index])
        appDelegate.saveContext()
        
        names.removeAtIndex(index)
        self.hitListTableView.reloadData()
    }
    
    func updateName(name: String, index: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let context = names[index]
        context.setValue(name, forKey: "name")
        do {
            try managedContext.save()
        } catch let error as NSError{
            print(error.userInfo)
        }
    }
}

