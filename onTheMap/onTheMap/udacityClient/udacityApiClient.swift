//
//  udacityApiClient.swift
//  onTheMap
//
//  Created by Saad altwaim on 10/25/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import Foundation

class udacityApiClient
{
    enum points
    {
        static let baseUrl = "https://onthemap-api.udacity.com/v1"
        
        case login
        //case studentNames(Int)
        case studentNames
        case userInfo(String)
        case addNewLocation
        var urlValue: String
        {
            switch self
            {
                case .login:
                    return points.baseUrl + "/session"
                case .studentNames : //.studentNames(let limit):
                    return points.baseUrl + "/StudentLocation?order=-updatedAt&limit=100" //
                case .userInfo(let userID):
                    return points.baseUrl + "/users/\(userID)"
                case .addNewLocation:
                    return points.baseUrl + "/StudentLocation"
            }
            
        }
        
        var url :URL
        {
            return URL(string: urlValue)!
        }
    }
    
    class func login(userName:String , passWord:String,completion: @escaping(Bool , Error?) -> Void)
    {
        var request = URLRequest(url: points.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = LoginRequest(username: userName, password: passWord)
        let body = udacityApiRequest(udacity: ["username" : requestBody.username,"password" : requestBody.password])
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request)
        {
            (Data,URLResponse,Error) in
            guard let data = Data
            else
            {
                completion(false,Error)
                print("Error IN the login Function ")
                return
            }
            do
            {
                let range = 5..<data.count
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(loginResponse.self, from: newData)
                print("THE RESPONSE :",responseObject)
                let authUser = responseObject.account.registered
                UserKey.Value = responseObject.account.key
                
                UserKey.sessionID = responseObject.session.id
                UserKey.ex = responseObject.session.ex
                print("THE VALUE OF THE auth IS : ",authUser)
                //print("THE VALUE OF THE USER KEY IS : ",userKey)
                //var array :String
                //array = userKey
                completion(authUser,nil)
                print("THE VALUE OF THE USER KEY IS",UserKey.Value)
            }
            catch
            {
                do
                {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    
                    let decoder = JSONDecoder()
                    let statusObject = try decoder.decode(StatusResopnse.self,from: newData) as Error //Note 1 Page 191
                    print(statusObject)
                    print("Message from the do in father catch ")
                    completion(false,statusObject)
                }
                catch
                {
                    print("Error IN the child catch from loging Function ")
                    completion(false,error)
                }

            }
        }
        task.resume()
        
    }
    
    //class func studentNames(completion : @escaping (Bool , Error?)-> Void)
    class func studentNames(completion : @escaping ([StudentInfoResponse] , Error?)-> Void)
    {        
        let task = URLSession.shared.dataTask(with: points.studentNames.url)
        {
            data,response,error in
            guard let Data = data
            else
            {
                //completion(false,error)
                completion([],error)
                print("Error IN studentNames Function ")
                return
            }
            do
            {
                //print("the studentNames URL",points.studentNames(5).url)
                //print("Raw JSON Data : ",String(data: Data, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let resultsObject = try decoder.decode(ResultsResponse.self, from: Data)
                
                //print("The ResultsResponse STRUCT : ",resultsObject)
                completion(resultsObject.results,error)// resultsObject.results
                //completion(true,error)
            }
            catch
            {
                print(error.localizedDescription)
                print("Error IN the catch from studentNames ")
                completion([],error)
                //completion(false,error)
            }

        }
        task.resume()
    }
    
    class func userInfo(id : String, completion : @escaping ([UserResponse], Error?)-> Void)
    {
        let task = URLSession.shared.dataTask(with: points.userInfo(id).url)
        {
            data, response, error in
            guard let Data = data
            else
            {
                completion([],error)
                print("Error from studentInfo")
                return
            }
            do
            {
                let range = 5..<Data.count
                let newData = Data.subdata(in: range) /* subset response data! */
                //print(String(data: newData, encoding: .utf8)!)
                
                print("the URL for userInfo ",points.userInfo(id).url)
                let decoder = JSONDecoder()
                let resultsObject = try decoder.decode(UserResponse.self, from: newData)
                print(resultsObject)
                completion([resultsObject], error)
                
            }
            catch
            {
                completion([],error)
                print(error.localizedDescription)
                print("Error IN the catch from userInfo ")
            }
        }
        task.resume()
    }
    
    class func addNewLocation(UniqueKey : String,FirstName:String,LastName:String,MapString:String,MediaURL:String,Latitude:Double,Longitude:Double,
    completion: @escaping(Bool , Error?) -> Void)
    {
        var request = URLRequest(url: points.addNewLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = StudentInfoResponse(firstName: FirstName, lastName: LastName, longitude: Longitude, latitude: Latitude,
        mapString: MapString, mediaURL: MediaURL, uniqueKey: UniqueKey)
        
        request.httpBody = try!JSONEncoder().encode(requestBody)
        let task = URLSession.shared.dataTask(with: request)
        {
            (Data,URLResponse,Error)in
            guard let data = Data
            else
            {
                completion(false,Error)
                print("Error IN the addNewLocation Function ")
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let resultsObject = try decoder.decode(AddLocationResponse.self, from: data)
                print("resultsObject From addNewLocation ",resultsObject)
                completion(true,Error)

            }
            catch
            {
                completion(false,error)
                print(error.localizedDescription)
                print("Error IN the catch addNewLocation ")
            }
        }
        task.resume()
    }
    class func logOut (completion : @escaping ()-> Void) // page 195
    {
        print("Session 1 ",UserKey.sessionID)
        var request = URLRequest(url: points.login.url)
        request.httpMethod = "DELETE"
        let body = SessionResopnse(id: UserKey.sessionID, ex: UserKey.ex)
        request.httpBody = try! JSONEncoder().encode(body)
        var xsrfCookie : HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!
        {
            if cookie.name == "XSRF-TOKEN"
            {
                xsrfCookie = cookie
            }
            if let xsrfCookie = xsrfCookie
            {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let task = URLSession.shared.dataTask(with: request)
            {
                (Data,URLResponse,Error) in
                guard let data = Data
                else
                {
                    completion()
                    print("Error IN the logOut Function ")
                    return
                }
                do
                {
                    
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    UserKey.sessionID = ""
                    print("Session 1 ",UserKey.sessionID)
                    completion()
                }
            }
            task.resume()
        }
    }
}
