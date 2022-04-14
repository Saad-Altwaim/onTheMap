//
//  ViewController.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/24/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import UIKit

class loginViewController: UIViewController
{
    @IBOutlet weak var studentUserName: UITextField!
    @IBOutlet weak var studentPassWord: UITextField!
    
   /* override func viewDidLoad()
    {
        super.viewDidLoad()
    }
*/
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        studentUserName.text = ""
        studentPassWord.text = ""
    }
    
    @IBAction func loginTapped()
    {
             
        loginButton(studentName:self.studentUserName.text ?? "" , studentPassword:self.studentPassWord.text ?? "" )
    }
    
    func loginButton(studentName :String , studentPassword:String)
    {
        udacityApiClient.login(userName: studentName, passWord: studentPassword,completion: self.handleLoginResponse(suceess:Error:))
    }
    
    func handleLoginResponse(suceess : Bool , Error :Error?)
    {
        if suceess == true
        {
            DispatchQueue.main.async
            {
                print("Message from handleLoginResponse")
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
                
            }
        }
        else
        {
            
            DispatchQueue.main.async
            {
                print("[Error]Message from handleLoginResponse")
                self.showLoginFailure(Message: Error?.localizedDescription ?? "" ) //Note 1 Page 191
            }
        }
    }
    
    func showLoginFailure(Message :String)
    {
        let alertVC = UIAlertController(title: "Login Failed", message: Message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

