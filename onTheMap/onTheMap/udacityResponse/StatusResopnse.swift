//
//  StatusResopnse.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/2/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct StatusResopnse :Codable
{
    let status :Int
    let error : String
    
    enum CodingKeys :String ,CodingKey
    {
        case status
        case error
    }
}

extension StatusResopnse : LocalizedError  
{
    var errorDescription: String?
    {
        return error
    }
}

