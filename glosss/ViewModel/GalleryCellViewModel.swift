//
//  GalleryCell.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation

class GalleryCellViewModel {
    let url: URL
    let ups: String
    let comments: String
    let views: String
    let mediaType: String
    
    init(item: GalleryItem) {
        func formatValue(_ value: Int) -> String {
            if value > 1000 {
                return "\(value / 1000)K"
            }
            
            return "\(value)K"
        }
        
        url = URL(string: item.imageLink)!
        ups = formatValue(item.ups-item.downs)
        comments = formatValue(item.commentCount)
        views = formatValue(item.views)
        mediaType = item.mediaType
    }
    
}
