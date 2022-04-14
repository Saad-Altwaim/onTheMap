//
//  ResultsResponse.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/2/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

struct ResultsResponse :Codable , Equatable
{
    let results : [StudentInfoResponse]
    
    enum CodingKeys :String ,CodingKey
    {
        case results
    }
}
