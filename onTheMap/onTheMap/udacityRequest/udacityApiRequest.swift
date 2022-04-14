//
//  udacityApiRequest.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/28/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct udacityApiRequest: Codable
{
    let udacity: Dictionary<String, String>

    enum CodingKeys: String, CodingKey
    {
        case udacity
    }
    
}
