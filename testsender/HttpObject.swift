//
//  HttpObject.swift
//  testsender
//
//  Created by Noverio Joe on 18/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

import UIKit

class HttpObject: NSObject,URLSessionDelegate {
    private var operationErrCode : String?
    
    private func setRequestData(requestDataParam : Any, httpRequestEnvelope : inout URLRequest, isSaveRequest : Bool, isSecuredRequest : Bool) -> Data?{
        var requestData : Data? = nil
        var payload : String! = ""
        
        
        requestData = try! JSONSerialization.data(withJSONObject: requestDataParam, options:[])
        payload = (String(data: requestData!, encoding: String.Encoding.utf8)!)
        print(payload)
        requestData = payload.data(using: .utf8)
        
        
        httpRequestEnvelope.httpMethod = "POST"
        httpRequestEnvelope.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        return requestData
    }
    
    private func setResponseData(dataResponse : inout Data, httpResponse : HTTPURLResponse, isSaveRequest : Bool, isSecuredResponse : Bool) -> [String:AnyObject?]{
        var parseResult : [String:AnyObject]?
        
        self.operationErrCode = "0000"
        
        do{
            if dataResponse.isEmpty == false {
                guard let convertToJson : [String:AnyObject] = try JSONSerialization.jsonObject(with: dataResponse, options:[]) as? [String:AnyObject]
                    else {
                        return [String:AnyObject]()
                }
                
                parseResult = convertToJson
            }
        }
        catch
        {
            
            self.operationErrCode = "99901"
            parseResult = [:]
        }
        
        
        return parseResult!
    }

    public func CallHTTPService(endpointURL : String!, jsonDataRequest : Any!, isSecuredRequest : Bool, httpComplete : @escaping (IOServiceModel) -> Void){
        
        let ioState : IOServiceModel = IOServiceModel()
        
        ioState.errCode = "9999"
        ioState.errMessage = "Unknown Error"
        ioState.anyDataJsonContent = "[empty]"
        
        var request = URLRequest(url:URL(string:endpointURL)!)
        let requestData = self.setRequestData(requestDataParam: jsonDataRequest, httpRequestEnvelope: &request, isSaveRequest: false, isSecuredRequest: isSecuredRequest)
        
        request.httpBody = requestData!
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 150.0
        sessionConfig.timeoutIntervalForResource = 180.0
        
        let session = URLSession(configuration: sessionConfig, delegate: HttpObject(), delegateQueue: nil)
        
        session.dataTask(with: request){
            (data,response, err) in
            var isNoError : Bool = true
            
            let httpStatusCode = (response as? HTTPURLResponse)?.statusCode
            if  httpStatusCode == 404{
                isNoError = false
                ioState.errMessage = "http connection failed"
            }
            
            //Guard: ws there error ?
            if(err != nil){
                
                isNoError = false
                ioState.errMessage = err?.localizedDescription
            }
            //Guard: check was any data returned?
            
            var data = data
            
            if data == nil{
                
                ioState.errMessage = "no data return"
                isNoError = false
            }
            
            if(isNoError == true){
                //Convert Json to Object
                var parseResult : [String:AnyObject]?
                
                let httpUrlResponse = response as? HTTPURLResponse
                parseResult = self.setResponseData(dataResponse: &data!, httpResponse: httpUrlResponse!, isSaveRequest: false, isSecuredResponse: isSecuredRequest) as [String : AnyObject]
                
                if (parseResult?.isEmpty)! == false{
                    DispatchQueue.main.sync{
                        ioState.errCode = self.operationErrCode
                        ioState.errMessage = "http request succeeded"
                        ioState.anyDataJsonContent = parseResult
                        httpComplete(ioState)
                    }
                }else{
                    DispatchQueue.main.sync{
                        ioState.errCode = "9901"
                        ioState.errMessage = "invalid response"
                        ioState.anyDataJsonContent = parseResult
                        httpComplete(ioState)
                    }
                }
                
            }else{
                DispatchQueue.main.sync{
                    ioState.errCode = "9999"
                    ioState.errMessage = "system unavailable"
                    ioState.anyDataJsonContent = nil
                    httpComplete(ioState)
                }
            }
            }.resume()
    }
    
}
