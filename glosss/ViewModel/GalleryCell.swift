//
//  GalleryCell.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation
import UIKit
import Nuke
import AVKit

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var upBalanceLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var placeholderView: UIImageView!
    
    private var isLoadingImage: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 6
        
        photoView.layer.cornerRadius = 6
        infoContainerView.layer.cornerRadius = 6
        
        photoView.layer.masksToBounds = true
        
        
        self.placeholderView.rotate()
    }
    
    func setUpBalance(to upBalance: String) {
        upBalanceLabel.text = upBalance
    }
    
    func setCommentCount(to commentCount: String) {
        commentCountLabel.text = commentCount
    }
    
    func setViewCount(to viewCount: String) {
        viewCountLabel.text = viewCount
    }
}

//MARK: - Animation Handler

extension GalleryCell {
    /// Nuke will check if the image exists in the memory cache,
    /// if it does, will instantly display it.
    /// If not, the image data will be loaded, decoded, processed, and decompressed in the background.
    func setPhoto(from url: URL) {
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "reload"),
            failureImage: UIImage(named: "hand"),
            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )

        Nuke.loadImage(
            with: url,
            options: options,
            into: photoView,
            progress: { [weak self] _, completed, total in
                guard let self = self else { return }

                if self.isLoadingImage == false {
                    self.isLoadingImage = true
                    self.photoView.backgroundColor = .clear
                }
            },
            completion: { [weak self] result in
                guard let self = self else { return }

                self.isLoadingImage = false
                self.placeholderView.isHidden = true

                switch result {
                case .success(_):
                    self.photoView.backgroundColor = .clear
                    break
                case .failure(_):
                    self.photoView.backgroundColor = UIColor.init(named: "image_reload")
                    break
                }
            }
        )
    }
    
    func setVideo(from url: URL) {
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = photoView.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        photoView.layer.addSublayer(playerLayer)
        player.play()
        player.volume = 0
    }

}
