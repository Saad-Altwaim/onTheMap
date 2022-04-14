//
//  LogoutViewController.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/21/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import UIKit

extension UIViewController
{
    @IBAction func logout()
    {
        udacityApiClient.logOut
        {
            DispatchQueue.main.async
            {
                print("the LOGOU is successful ")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
