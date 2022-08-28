import Foundation
import shared
import Utilities

public struct CompactCellViewModel: Identifiable {
	public let image: URL?
	public let name: String
	public let subtitle: String
	public let modelID: String
	public var id: ObjectIdentifier { modelID.objectIdentifier }
}

public extension CompactCellViewModel {
	init(artist: Artist) {
		if let imageUrl = URL(string: artist.image) {
			self.image = imageUrl
		} else {
			Log("bad artist image URL")
			image = nil
		}
		subtitle = "5 songs"
		name = artist.name
		modelID = artist.id
	}
	
	init(playlist: Playlist) {
		if let imageUrl = URL(string: playlist.image) {
			self.image = imageUrl
		} else {
			Log("bad artist image URL")
			image = nil
		}
		subtitle = "5 songs"
		name = playlist.title
		modelID = playlist.playlistId
	}
}
