import SwiftUI
import ModuleLinker
import Resolver
import SharedUI
import Fonts

struct PlaylistListViewCell: View {
	let playlist: PlaylistListViewModel.Playlist
	let imageSize: CGFloat = 80
	
	@Injected private var colorProvider: ColorProviding
	
	var body: some View {
		HStack {
			AsyncImage(url: playlist.image) { phase in
				if case let .success(image) = phase {
					image
						.circleImage(size: imageSize)
						.padding(.trailing)
				}
			}
			VStack {
				title
				creator
				genreStarsPlays
			}
		}
		.frame(alignment: .leading)
		.padding()
		.padding(.trailing)
		.background(LinearGradient(colors: [colorProvider.color(for: .newmOffPink), colorProvider.color(for: .newmYellow)], startPoint: .top, endPoint: .bottom).opacity(0.31))
		.cornerRadius(imageSize)
	}
	
	private var title: some View {
		HStack {
			Text(playlist.title)
				.foregroundColor(.white)
				.font(.robotoMedium(ofSize: 14))
			Spacer()
		}
		.padding(.bottom, 1)
	}
	
	private var creator: some View {
		HStack {
			Text(playlist.creator)
				.foregroundColor(colorProvider.color(for: .newmPink))
				.font(.roboto(ofSize: 11))
			Spacer()
		}
		.padding(.bottom)
	}
	
	private var genreStarsPlays: some View {
		HStack {
			Text(playlist.genre)
			Text(playlist.starCount)
			Text(playlist.playCount)
			Spacer()
		}
		.font(.roboto(ofSize: 10))
		.foregroundColor(.white.opacity(0.97))
	}
}

struct PlaylistListViewCell_Previews: PreviewProvider {
	static var previews: some View {
		PlaylistListViewCell(playlist: PlaylistListViewModel.Playlist(MockPlaylistListUseCase().execute().first!))
			.preferredColorScheme(.dark)
	}
}
