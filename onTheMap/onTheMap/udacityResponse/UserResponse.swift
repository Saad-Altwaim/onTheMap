//
//  UserResponse.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/16/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct UserResponse :Codable 
{
    //let user : UserProfileResponse
    let last_name : String
    let first_name: String
    //let key : String
    
    enum CodingKeys :String ,CodingKey
    {
        case last_name
        case first_name
        //case key
    }
}
