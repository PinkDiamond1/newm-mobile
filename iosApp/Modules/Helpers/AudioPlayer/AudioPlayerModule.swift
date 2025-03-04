import Foundation
import ModuleLinker
import Resolver

public final class AudioPlayerModule: ModuleProtocol {
	public static var shared = AudioPlayerModule()
	
	public func registerAllServices() {
		Resolver.register {
			AudioPlayerImpl.shared
		}.scope(.application)
	}
	
	public func registerAllMockedServices(mockResolver: Resolver) {
		
	}
}
