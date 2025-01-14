import Foundation
import API
import KeychainSwift
import FacebookLogin
import GoogleSignIn
import AuthenticationServices

enum LoginError: Error {
	case facebookAccessTokenMissing
}

public class LoginManager: ObservableObject {
	//TODO: update this with user info
	@Published public var userIsLoggedIn: Bool = false
	let api = LoginAPI()
	
	var appleSignInID: String?
	
	public init() {
		api.$userIsLoggedIn.assign(to: &$userIsLoggedIn)
	}
		
	public func loginWithFacebook(result: LoginManagerLoginResult) async throws {
		do {
			guard let token = result.token?.tokenString else {
				throw LoginError.facebookAccessTokenMissing
			}
			try await api.login(method: .facebook(accessToken: token))
		} catch {
			Task { @MainActor in
				FacebookLogin.LoginManager().logOut()
			}
			throw error
		}
	}
	
	public func loginWithGoogle(result: GIDSignInResult) async throws {
		let token = result.user.accessToken.tokenString
		try await api.login(method: .google(accessToken: token))
	}
	
	public func login(email: String, password: String) async throws {
		try await api.login(method: .email(email: email, password: password))
	}
		
	public func logOut() {
		api.logOut()
		FacebookLogin.LoginManager().logOut()
		GIDSignIn.sharedInstance.signOut()
		signOutOfApple()
	}
	
	public func requestEmailVerificationCode(for email: String) async throws {
		try await api.requestEmailVerificationCode(for: email)
	}
	
	public func loginWithApple(result: ASAuthorization) async throws {
		let token = String(data: (result.credential as! ASAuthorizationAppleIDCredential).identityToken!, encoding: .utf8)!
		try await api.login(method: .apple(idToken: token))
	}
	
	private func signOutOfApple() {
		//TODO:
	}
}
