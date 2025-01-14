import Foundation
import Resolver
import Auth
import GoogleSignIn
import FacebookLogin
import AuthenticationServices

@MainActor
class LandingViewModel: ObservableObject {
	@Published var navPath = [LandingRoute]()
	
	@Published var error: String?
	@Published var isLoading: Bool = false
	
	@Published var confirmationCode = ""
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var confirmPassword: String = ""
	@Published var nickname: String = ""
			
	private let loginManager = Auth.LoginManager()
	private let userManager = UserManager()
	private let loginFieldValidator = LoginFieldValidator()

	var nicknameIsValid: Bool {
		nickname.count > 0
	}
		
	var createAccountFieldsAreValid: Bool {
		password == confirmPassword &&
		loginFieldValidator.validate(email: email, password: password)
	}
	
	var loginFieldsAreValid: Bool {
		loginFieldValidator.validate(email: email, password: password)
	}
	
	var confirmationCodeIsValid: Bool {
		confirmationCode.count == 6
	}
	
	func goToLogin() {
		navPath.append(.login)
	}
	
	func login() {
		isLoading = true
		Task {
			do {
				try await loginManager.login(email: email, password: password)
			} catch {
				self.error = "\(error)"
			}
			isLoading = false
		}
	}
	
	func forgotPassword() {
		navPath.append(.forgotPassword)
	}
	
	func requestPasswordResetCode() {
		navPath.append(.enterNewPassword)
		Task {
			do {
				try await loginManager.requestEmailVerificationCode(for: email)
			} catch {
				self.error = "\(error)"
			}
		}
	}
	
	func resetPassword() {
		Task {
			do {
				try await userManager.resetPassword(email: email, password: password, confirmPassword: confirmPassword, authCode: confirmationCode)
				try await loginManager.login(email: email, password: password)
			} catch {
				self.error = "\(error)"
			}
		}
	}
	
	func createAccount() {
		navPath.append(.createAccount)
	}
	
	func requestVerificationCode() {
		if !navPath.contains(.codeConfirmation) {
			navPath.append(.codeConfirmation)
		}
		Task {
			do {
				try await loginManager.requestEmailVerificationCode(for: email)
			} catch {
				self.error = "\(error)"
			}
		}
	}
	
	func requestNickname() {
		navPath.append(.nickname)
	}
	
	func registerUser() {
		isLoading = true
		Task {
			do {
				try await userManager.createUser(nickname: nickname, email: email, password: password, passwordConfirmation: confirmPassword, verificationCode: confirmationCode)
				navPath.append(.done)
			} catch let error as UserManagerError {
				switch error {
				case .accountExists:
					self.error = "An account with this email already exists."
					navigateBackTo(.createAccount)
				case .twoFAFailed:
					self.error = "You entered the incorrect verification code."
					navigateBackTo(.codeConfirmation)
				}
			} catch {
				self.error = "\(error)"
			}
			
			isLoading = false
		}
	}
	
	func navigateBackTo(_ navRoute: LandingRoute) {
		navPath = Array(navPath.prefix(through: navPath.firstIndex(of: navRoute)!))
	}
	
	func reset() {
		navPath = []
	}
		
	func handleFacebookLogin(result: Result<LoginManagerLoginResult, Error>) {
		switch result {
		case .success(let loginResult):
			isLoading = true
			Task {
				do {
					try await loginManager.loginWithFacebook(result: loginResult)
				} catch {
					self.error = "\(error)"
				}
				isLoading = false
			}
		case .failure(let error):
			self.error = "\(error)"
		}
	}
	
	func handleFacebookLogout() {
		loginManager.logOut()
	}
	
	func handleGoogleSignIn(result: GIDSignInResult?, error: Error?) {
		guard let result = result, error == nil else {
			self.error = String(describing: error)
			return
		}
		
		isLoading = true
		Task {
			do {
				try await loginManager.loginWithGoogle(result: result)
			} catch {
				self.error = "\(error)"
			}
			isLoading = false
		}
	}
	
	func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
		switch result {
		case .success(let authResults):
			isLoading = true
			Task {
				do {
					try await LoginManager().loginWithApple(result: authResults)
				} catch {
					self.error = "\(error)"
				}
				isLoading = false
			}
		case .failure(let error):
			self.error = "\(error)"
		}
	}
}
