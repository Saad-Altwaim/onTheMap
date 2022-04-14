//
//  AddLocationResponse.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/17/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct AddLocationResponse : Codable
{
    let objectId : String
    //let createdAt : Date
    
    enum CodingKeys :String ,CodingKey
    {
        case objectId
       // case createdAt
    }
}
// {"objectId":"buq1durv1er0h4lq11p0","createdAt":"2020-11-17T18:31:23.588Z"}
