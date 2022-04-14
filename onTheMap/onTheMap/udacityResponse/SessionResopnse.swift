//
//  SessionResopnse.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/29/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct SessionResopnse :Codable
{
    let id : String
    let ex : String
    
    enum CodingKeys :String ,CodingKey
    {
        case id
        case ex = "expiration"
    }
}
