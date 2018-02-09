//
//  VideoView.swift
//  Test
//
//  Created by Samuel Huang on 2/8/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    var url: URL?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var playerItem: AVPlayerItem? {
        didSet {
            guard let item = playerItem else {
                player = nil
                return
            }

            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForegroundNotification), name: .UIApplicationWillEnterForeground, object: nil)

            player = AVPlayer(playerItem: item)
            player?.isMuted = true
            videoCompletedLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill // TODO: Update our stuff to support aspect ratios other than 1
            videoCompletedLayer?.player = self.player
            player?.actionAtItemEnd = AVPlayerActionAtItemEnd.none

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerItemDidReachEnd),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: playerItem)

        }
    }

    var videoCompletedLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero)
        }
    }

    func loadFromURL() {
        guard let url = self.url else { return }
        playerItem = AVPlayerItem(url: url)
    }

    func reset() {
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
        videoCompletedLayer?.player = nil
    }

    func pause() {
        player?.pause()
    }

    func play() {
        if playerItem != nil {
            player?.play()
            return
        }
    }

    @objc func appWillEnterForegroundNotification() {
        player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        videoCompletedLayer?.player = nil
    }
}
