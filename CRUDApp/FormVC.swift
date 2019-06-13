//
//  FormVC.swift
//  CRUDApp
//
//  Created by Techno-MAC on 13/06/19.
//  Copyright © 2019 Techno-MAC. All rights reserved.
//

import UIKit
import Firebase

class FormVC: UIViewController {

    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var workDescription: UITextView!
    
    var updateflag : Bool?
    var work_title : String?
    var workDetails : String?
    var id : String?
    
    var refUser: DatabaseReference!
    static let shared = FormVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        refUser = Database.database().reference().child("User")
        titleTF.layer.borderColor = #colorLiteral(red: 0.9518287778, green: 0.5164368749, blue: 0.213540405, alpha: 1)
        titleTF.layer.borderWidth = 1.5
  
        workDescription.layer.borderColor = #colorLiteral(red: 0.9518287778, green: 0.5164368749, blue: 0.213540405, alpha: 1)
        workDescription.layer.borderWidth = 1.5
        
      submitbtn.layer.cornerRadius = submitbtn.frame.size.height / 2
       titleTF.layer.cornerRadius = 5
        workDescription.layer.cornerRadius = 5
        if updateflag == true
        {
           self.submitbtn.setTitle("Update", for: .normal)
            self.titleTF.text = work_title
            self.workDescription.text = workDetails
        }
        else
        {
            self.submitbtn.setTitle("Submit", for: .normal)
            
        }
        // Do any additional setup after loading the view.
        titleTF.setLeftPaddingPoints(8.0)
        titleTF.setRightPaddingPoints(8.0)
    }
  
    @IBAction func submitAction(_ sender: Any) {
        if updateflag == false
        {
            if titleTF.text != "" || workDescription.text != ""
            {
              
                
               addUser()
                self.navigationController?.popViewController(animated: true)
                
                
            }
        }
        else
        {
            if titleTF.text != ""
            {
                updateToFireBase(id: id!, title: titleTF.text!, workDescription: workDescription.text!)
                DatabaseManager.shared.updateData(empId: id!, title: titleTF.text!, workDescription: workDescription.text!) { (result) in
                    print(result)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
       
        
    }
    func addUser(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refUser.childByAutoId().key
        
        //creating artist with the given values
        let userinfo = ["id":key,
                      "title": titleTF.text!,
                      "workDescription": workDescription.text!
        ]
    
       
        refUser.child(key!).setValue(userinfo)
        
        //displaying message
        DatabaseManager.shared.saveUserData(empId: key!, title: titleTF.text!, workDescription: workDescription.text!) { (result) in
            print(result)
        }
        print("User Added")
    }
    
    func updateToFireBase(id:String,title:String, workDescription : String){
        //creating artist with the new given values
        let user = ["id":id,
                      "title": title,
                      "workDescription": workDescription
        ]
        
        //updating the artist using the key of the artist
        refUser.child(id).setValue(user)
        
        //displaying message
        print("user Updated")
    }
}
extension UITextField
{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
