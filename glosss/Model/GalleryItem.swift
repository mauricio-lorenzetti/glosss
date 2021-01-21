//
//  GalleryItem.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation

struct GalleryItem {
    let imageLink, mediaType: String
    let views, ups, downs, commentCount: Int
}

extension GalleryItem {
    init?(from json: [String: Any]) {
        guard
            let images = json["images"] as? [[String: Any]],
            let views = json["views"] as? Int,
            let ups = json["ups"] as? Int,
            let downs = json["downs"] as? Int,
            let commentCount = json["comment_count"] as? Int
        else { return nil }
        
        let imageLink = images.compactMap({ $0["link"] })[0] as! String
        let mediaType = images.compactMap({ $0["type"] })[0] as! String
        
        // self-resizing cells
        //images.compactMap({print($0["height"])})
        
        self.init(imageLink: imageLink, mediaType: mediaType ,views: views, ups: ups, downs: downs, commentCount: commentCount)
    }
}
