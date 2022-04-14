//
//  StudentInfoResponse.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/2/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct StudentInfoResponse :Codable , Equatable
{
    let firstName : String
    let lastName  : String
    let longitude : Double
    let latitude  : Double
    let mapString : String
    let mediaURL  : String
    let uniqueKey : String
    //let objectId  : String
   // let createdAt : Date
   // let updatedAt : Date
    
    
    enum CodingKeys :String ,CodingKey
    {
        case firstName
        case lastName
        case longitude
        case latitude
        case mapString
        case mediaURL
        case uniqueKey
        //case objectId
       // case createdAt
       // case updatedAt
        
    }
}
