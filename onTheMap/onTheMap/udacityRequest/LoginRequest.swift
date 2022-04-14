//
//  loginRequest.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/26/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct LoginRequest : Codable
{
    let username   : String
    let password   : String
    
    enum CodingKeys :String ,CodingKey
    {
        case username
        case password
    }
}

