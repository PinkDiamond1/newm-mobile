import Foundation
import UIKit.UIImage
import Resolver
import ModuleLinker
import shared
import Utilities

class PlaylistListViewModel: ObservableObject {
	@Injected private var playlistListUseCase: PlaylistListUseCaseProtocol
	
	@Published var playlists: [Playlist] = []

	init() {
		playlists = playlistListUseCase.execute().map(PlaylistListViewModel.Playlist.init)
	}
}

extension PlaylistListViewModel {
	struct Playlist: Identifiable {
		let image: URL?
		let title: String
		let creator: String
		let genre: String
		let starCount: String
		let playCount: String
		let playlistID: String
		var id: ObjectIdentifier { playlistID.objectIdentifier }
		
		init(image: URL?, title: String, creator: String, genre: String, starCount: String, playCount: String, playlistID: String) {
			self.image = image
			self.title = title
			self.creator = creator
			self.genre = genre
			self.starCount = starCount
			self.playCount = playCount
			self.playlistID = playlistID
		}
		
		init(_ playlist: shared.Playlist) {
			let imageUrl = URL(string: playlist.image)
			if imageUrl == nil {
				Log("bad image in \(Self.self)")
			}
			self.init(
				image: imageUrl,
				title: playlist.title,
				creator: playlist.creator.userName,
				genre: playlist.genre,
				starCount: "\(playlist.starCount) ✭",
				playCount: "\(playlist.playCount)",
				playlistID: playlist.playlistId
			)
		}
	}
}
