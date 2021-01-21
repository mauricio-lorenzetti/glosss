//
//  File.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation
import RxSwift
import RxCocoa

class GalleryViewModel {
    
    let reload: AnyObserver<Void>
    
    let galleries: Observable<[GalleryCellViewModel]>
    
    let errors: Observable<String>
    
    init(imgurService: ImgurService = ImgurService() ) {
        let _reload = PublishSubject<Void>()
        reload = _reload.asObserver()
        
        let res = _reload.flatMapLatest { (_) in
            return imgurService.fetch().materialize()
        }.share()
        
        galleries = res.compactMap { $0.element?.map(GalleryCellViewModel.init) }
        
        errors = res.compactMap({ $0.error?.localizedDescription })
        
    }
}
