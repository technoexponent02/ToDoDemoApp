//
//  ViewController.swift
//  CRUDApp
//
//  Created by Techno-MAC on 13/06/19.
//  Copyright © 2019 Techno-MAC. All rights reserved.
//

import UIKit
import  Firebase
class ViewController: UIViewController {

    @IBOutlet weak var dataListTableView: UITableView!
    var userInfo = [User]()
    var refUser: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        refUser = Database.database().reference().child("User")
        self.title = "TO-DO LIST"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToFormPage)), animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DatabaseManager.shared.fetchData { (result) in
           switch result
           {
           case .success ( let data ):
                userInfo = data as! [User]
           case .failure(_):
            
            break
            
            }
        }
        
        
        //observing the data changes
        refUser.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                
                //iterating through all the values
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let itemObject = item.value as? [String: AnyObject]
                    let title  = itemObject?["title"] as? String
                    let id  = itemObject?["id"] as? String
                    let workDescription = itemObject?["workDescription"] as? String
                    
                   if title != nil && id != nil && workDescription !=  nil
                   {
                    DatabaseManager.shared.updateData(empId: id!, title: title!, workDescription: workDescription!, completion: { (_) in
                        
                    })
                    }
                }
            }
             self.dataListTableView.reloadData()
        })
        self.dataListTableView.reloadData()
    }

    @objc func pushToFormPage()
    {
        let formVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormVC") as! FormVC
        formVC.updateflag = false
        self.navigationController?.pushViewController(formVC, animated: true)
    }
}


extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! informationCell
        cell.id.text = userInfo[indexPath.row].id
        cell.title.text = userInfo[indexPath.row].title
        cell.workDescription.text = userInfo[indexPath.row].workDescription
        cell.containerView.layer.cornerRadius = 6
        cell.containerView.layer.borderColor = #colorLiteral(red: 0.9518287778, green: 0.5164368749, blue: 0.213540405, alpha: 1)
        cell.containerView.layer.borderWidth = 1.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteArtist(id: userInfo[indexPath.row].id!)
            DatabaseManager.shared.deleteData(empID: userInfo[indexPath.row].id!) { (result) in
                switch result
                {
                case .success ( let data ):
                    print(data)
                    self.userInfo.remove(at: indexPath.row)
                    
                    self.dataListTableView.deleteRows(at: [indexPath], with: .automatic)
                    print(data)
                    
                case .failure(_):
                    
                    break
                    
                }
            }
           
          
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormVC") as! FormVC
        formVC.id = userInfo[indexPath.row].id
        formVC.work_title = userInfo[indexPath.row].title
        formVC.workDetails = userInfo[indexPath.row].workDescription
        formVC.updateflag = true
        self.navigationController?.pushViewController(formVC, animated: true)
    }
    
    func deleteArtist(id:String){
       refUser.child(id).setValue(nil)
        
        //displaying message
        print(" Deleted")
    }
}
