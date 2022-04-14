//
//  loginResponse.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/29/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct loginResponse :Codable
{
    let account : accountResponse // Note 2 Page 191
    let session : SessionResopnse
    
    enum CodingKeys :String ,CodingKey
    {
        case account
        case session
    }
}
