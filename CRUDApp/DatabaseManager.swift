//
//  DatabaseManager.swift
//  CRUDApp
//
//  Created by Techno-MAC on 13/06/19.
//  Copyright © 2019 Techno-MAC. All rights reserved.
//

import UIKit
import CoreData

enum Result
{
    case success(Any)
    case failure(String)
}
typealias DBResult = (Result)->()
class DatabaseManager: NSObject {
    
    static let shared = DatabaseManager()
    let manageObjectContest : NSManagedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userInfo = [User]()
    public override init()
    {
        manageObjectContest = appDelegate.persistentContainer.viewContext
    }
    
    
    //MARK: for saving/insert data into database::---->>
    
    func saveUserData(empId : String , title : String , workDescription : String , completion : DBResult)
    {
        let userInfo = User(context: manageObjectContest)
        userInfo.id = empId
        userInfo.title = title
        userInfo.workDescription = workDescription
        
        do{
            try manageObjectContest.save()
            completion(.success("Saved Successfully"))
        }
        catch
        {
            completion(.failure("Data not saved properly!!"))
        }
        
    }
    
     //MARK: for fetch data into database::---->>
    
    func fetchData(completion : DBResult)
    {
        let fetchRequest = User.fetchRequest() as NSFetchRequest
        do{
            try userInfo = manageObjectContest.fetch(fetchRequest) as [User]
            completion(.success(userInfo))
        }
        catch
        {
            completion(.failure("Fetching Promlem !!"))
        }
    }
    
     //MARK: for Delete data into database::---->>
    
    func deleteData(empID : String, completion : DBResult)
    {
        let fetchRequest = User.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "id == %@", empID)
        do
        {
            let result = try manageObjectContest.fetch(fetchRequest) as [User]
            for item in result
            {
                manageObjectContest.delete(item)
            }
            try manageObjectContest.save()
            if result.count > 0
            {
                completion(.success("Deleted Successfully!!"))
            }
            else
            {
                completion(.failure("Not Deleted"))
            }
        }
        catch
        {
            completion(.failure(error.localizedDescription))
        }
    }
    
     //MARK: for Update data into database::---->>
    
    func updateData(empId : String , title : String , workDescription : String , completion : DBResult)
    {
        let fetchRequest = User.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "id == %@", empId)
        fetchRequest.predicate = predicate
         do
         {
            let result = try manageObjectContest.fetch(fetchRequest) as [User]
            if result.count > 0
            {
                for item in result
                {
                    item.title = title
                    item.workDescription = workDescription
                    
                }
               
                try manageObjectContest.save()
                 print("update Successfully")
                completion(.success("updated successfully"))
            }
            else
            {
                completion(.failure("Not upadted!!"))
            }
        }
        catch
        {
            completion(.failure("Not upadted!!"))
        }
    }
}
