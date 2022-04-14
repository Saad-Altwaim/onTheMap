//
//  accountResponse.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/29/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct accountResponse :Codable
{
    let registered : Bool
    let key        : String
    
    enum CodingKeys :String ,CodingKey
    {
        case registered
        case key
    }
}
