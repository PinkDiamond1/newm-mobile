import Foundation
import ModuleLinker
import Resolver
import SwiftUI

public final class SongPlayingModule: ModuleProtocol {
	public static var shared = SongPlayingModule()
	
	public func registerAllServices() {
		Resolver.register {
			self as SongPlayingViewProviding
		}
		
		Resolver.register { resolver, args in
			SongPlayingViewModel(
				songInfoUseCase: resolver.resolve(SongInfoUseCaseProtocol.self, args: args),
				musicPlayerUseCase: resolver.resolve(MusicPlayerUseCaseProtocol.self, args: args)
			)
		}
		
		//TODO: Register real dependencies
		
//		Resolver.register { resolver, args in
//			MusicPlayerUseCase() as MusicPlayerUseCaseProtocol
//		}
		
//		Resolver.register { resolver, args in
//			SongInfoUseCase(id: args()) as SongInfoUseCaseProtocol
//		}
	}
}

extension SongPlayingModule: SongPlayingViewProviding {
	public func songPlayingView(id: String) -> AnyView {
		SongPlayingView(id: id).erased
	}
}

#if DEBUG
extension SongPlayingModule {
	public func registerAllMockedServices(mockResolver: Resolver) {
		Resolver.register { resolver, args in
			MockMusicPlayerUseCase(id: args()) as MusicPlayerUseCaseProtocol
		}
		
//TODO: Hook up real Use Case
		Resolver.register { resolver, args in
			MockSongInfoUseCase(id: args()) as SongInfoUseCaseProtocol
		}
	}
}
#endif
