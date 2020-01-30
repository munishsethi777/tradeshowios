//
//  UserMgr.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 27/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import CoreData
class UserMgr{
    static let sharedInstance = UserMgr()
    let coreDataManager = CoreDataManager(modelName: "alpinebi")
    func saveUser(response: [String: Any]){
        let userJson = response["user"] as! [String:Any]
        var user = NSEntityDescription.insertNewObject(forEntityName: "User", into: coreDataManager.managedObjectContext) as! User
        let userSeq = Int(userJson["seq"] as! String)! ;
        let existingUser = getUserByUserSeq(userSeq: userSeq) as User?
        if(existingUser != nil){
            user = existingUser!;
        }
        user.fullname = userJson["fullname"] as? String
        user.userseq = Int32(userSeq)
        user.email = userJson["email"] as? String
        user.usertype = userJson["usertype"] as? String
        user.qccode = userJson["qccode"] as? String
        user.mobile = userJson["mobile"] as? String
        do {
            try coreDataManager.managedObjectContext.save()
            PreferencesUtil.sharedInstance.setLoggedInUserSeq(userSeq: Int(user.userseq))
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    func updateUser(response: [String: Any]){
        let userSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userseq == %d", userSeq)
        do
        {
            let fetchedUsers = try coreDataManager.managedObjectContext.fetch(fetchRequest) as? [User]
            if fetchedUsers?.count == 1
            {
                let userJson = response["user"] as! [String:Any]
                var user = fetchedUsers![0]
                let userSeq = Int(userJson["id"] as! String)! ;
                let existingUser = getUserByUserSeq(userSeq: userSeq) as User?
                if(existingUser != nil){
                    user = existingUser!;
                }
                user.fullname = userJson["fullName"] as? String
                user.userseq = Int32(userJson["id"] as! String)!
                user.email = userJson["email"] as? String
                user.usertype = userJson["userType"] as? String
                user.qccode = userJson["qccode"] as? String
                user.mobile = userJson["mobile"] as? String
                do{
                    try coreDataManager.managedObjectContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        }
        catch
        {
            print(error)
        }
    }

    func getUserByUserSeq(userSeq: Int)->User?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let id = String(userSeq)
        fetchRequest.predicate = NSPredicate(format: "userseq == %d", userSeq)
        do {
            let fetchedUsers = try coreDataManager.managedObjectContext.fetch(fetchRequest) as? [User]
            return fetchedUsers?.first
        } catch {
            fatalError("Failure to get context: \(error)")
        }
    }
}

