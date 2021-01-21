//
//  ViewController.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyView: UIView!
    
    private let galleryViewModel = GalleryViewModel()
    private let disposeBag = DisposeBag()
    private let refreshControl = CustomRefreshControl()
    @IBOutlet weak var reloadImageView: UIImageView!
    
//    var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        let width = UIScreen.main.bounds.size.width
//        layout.estimatedItemSize = CGSize(width: width, height: 240)
//        return layout
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBindings()
        
        collectionView.delegate = self
        //collectionView?.collectionViewLayout = layout
        
        refreshControl.sendActions(for: .valueChanged)
    }
    
    func setup() {
        collectionView.register(UINib(nibName: "GalleryCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCell")
        collectionView.addSubview(refreshControl)
        reloadImageView.rotate()
    }

    func setupBindings() {
        galleryViewModel.galleries.observe(on: MainScheduler.instance).do(onNext: { [weak self] result in self?.emptyView.isHidden = true}).bind(to: collectionView.rx.items(cellIdentifier: "GalleryCell", cellType: GalleryCell.self)) { [weak self] (_, model, cell) in
            guard let self = self else { return }
            self.setupGalleryCell(cell, cellViewModel: model)
        }.disposed(by: disposeBag)
        
        galleryViewModel.errors
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.emptyView.isHidden = false
                self.collectionView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.galleryViewModel.reload.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: galleryViewModel.reload)
            .disposed(by: disposeBag)
    }
    
    private func setupGalleryCell(_ cell: GalleryCell, cellViewModel: GalleryCellViewModel) {
        cell.setUpBalance(to: cellViewModel.ups)
        cell.setCommentCount(to: cellViewModel.comments)
        cell.setViewCount(to: cellViewModel.views)
        if cellViewModel.mediaType.contains("video") {
            cell.setVideo(from: cellViewModel.url)
        } else {
            cell.setPhoto(from: cellViewModel.url)
        }
    }

}

extension GalleryViewController: UICollectionViewDelegate {
    
}

//extension GalleryViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 340, height: 240)
//    }
//}

extension GalleryViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControl.containingScrollViewDidEndDragging(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.didScroll(scrollView)
    }
}
