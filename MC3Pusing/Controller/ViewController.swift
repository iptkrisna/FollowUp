//
//  ViewController.swift
//  CloudKit-Test
//
//  Created by I Putu Krisna on 19/08/19.
//  Copyright © 2019 I Putu Krisna. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    let database = CKContainer.default().privateCloudDatabase
    var record = [CKRecord]()
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBAction func btnSave(_ sender: Any) {
        save(name: txtName.text!)
        
    }
    
    @IBAction func btnFetch(_ sender: Any) {
        retrieve()
        let name = record.last?.value(forKey: "Name")
        lblName.text = name as? String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func save(name: String){
        let newName = CKRecord.init(recordType: "Data")
        newName.setValue(name, forKey: "Name")
        database.save(newName) { (record, error) in
            guard record != nil else {return}
            print("success")
        }
        
    }
    
    func retrieve(){
        let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else {return}
            
            let sortRecords = records.sorted(by: { $0.creationDate! < $1.creationDate!
            })
            
            self.record = sortRecords
            print(self.record)
            
            let name = self.record.last?.value(forKey: "Name") as? String
            
            DispatchQueue.main.async {
                self.lblName.text = name
            }
        }
    }
    
}

