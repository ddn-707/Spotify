//
//  PlayPresenter.swift
//  Spotify-iOS
//
//  Created by DND on 11/06/2024.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource : AnyObject {
    var songName: String? {get}
    var subtitle: String? {get}
    var imageURL: URL? {get}
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    //
    private var tracks: [AudioTrack] = []
    //
    //    var index = 0
    
    //    var currentTrack : AudioTrack? {
    //        if let
    //    }
    var playerVC: PlayerViewController?
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    func startPlayback(from viewController: UIViewController, track: AudioTrack){
        guard let url = URL(string:  track.preview_url ?? "")else{
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.3
        
        self.track = track
        self.tracks = []
        
        let vc = PlayerViewController()
        vc.title = track.name
        
        vc.delegate = self
        vc.dataSource = self
        
        viewController.present(
            UINavigationController(rootViewController: vc),
            animated: true) {
                [weak self] in self?.player?.play()
            }
        self.playerVC = vc
        
    }
    
    func startPlayback(from viewController : UIViewController , tracks: [AudioTrack]){
        
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(
            items: tracks.compactMap({
                guard let url = URL(string: $0.preview_url ?? "") else {
                    return nil
                }
                return AVPlayerItem(url: url)
            })
        )
        
        let vc = PlayerViewController()
        vc.title = tracks.first?.name
        
        vc.delegate = self
        vc.dataSource = self
        
        viewController.present(
            UINavigationController(rootViewController: vc),
            animated: true,
            completion: nil
        )
        
        self.playerVC = vc
    }
    
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        
    }
    
    func didTapForward() {
        
    }
    
    func didTapBackward() {
        
    }
    
    func didSlideSlider(_ value: Float) {
        
    }
    
    
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return ""
    }
    
    var subtitle: String? {
        return ""
    }
    
    var imageURL: URL? {
        return URL(string: "String")
    }
    
    
}

