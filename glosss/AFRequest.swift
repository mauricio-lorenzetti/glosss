//
//  AFRequest.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation
import Alamofire

class AFRequest {
    func get(url: URL, onSuccess: @escaping (_ json: Data) -> Void) {//, onError: @escaping ErrorClosure) {

        let headers: HTTPHeaders = [
            "Authorization": ImgurAPI.authorization,
            "Accept": "application/json"
        ]

        AF.request(url, headers: headers).responseData { (response) in
                if let error = response.error {
                    print(error.errorDescription ?? "unknown error")
                    return
                }
                guard let data = response.value else {
                    return
                }
                onSuccess(data)
        }
    }
}

