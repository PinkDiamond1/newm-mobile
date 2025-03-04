import Foundation
import Resolver
import ModuleLinker
import SwiftUI

public final class HomeModule: ModuleProtocol {
	public static let shared = HomeModule()
	
	public func registerAllServices() {
		Resolver.register {
			self as HomeViewProviding
		}
		
		Resolver.register {
			HomeViewModel()
		}
	}
}

#if DEBUG
extension HomeModule {
	public func registerAllMockedServices(mockResolver: Resolver) {
		mockResolver.register {
			MockHomeViewUIModelProvider(actionHandler: $0.resolve()) as HomeViewUIModelProviding
		}
	}
}
#endif
