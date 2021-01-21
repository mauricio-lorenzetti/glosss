//
//  ImgurService.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum ErrorService: Error {
    case cannotParse
}

class ImgurService {
    
    private let _session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        _session = session
    }
    
    func fetch() -> Observable<[GalleryItem]> {
        let resource = ImgurAPI.resourceURL.gallery(section: .top,
                                                sort: .top,
                                                window: .week,
                                                showViral: false,
                                                mature: false,
                                                albumPreviews: false).URLValue
        var request = URLRequest(url: resource)
        
        request.headers.add(HTTPHeader(name: "Authorization", value: ImgurAPI.authorization))
        request.headers.add(HTTPHeader(name: "Accept", value: "application/json"))
        
        return _session.rx.json(request: request).flatMap { json throws -> Observable<[GalleryItem]> in
            guard
                let json = json as? [String: Any],
                let dataJson = json["data"] as? [[String: Any]]
            else { return Observable.error(ErrorService.cannotParse) }
            
            let galleries = dataJson.compactMap(GalleryItem.init)
            
            return Observable.just(galleries)
        }
    }
}
