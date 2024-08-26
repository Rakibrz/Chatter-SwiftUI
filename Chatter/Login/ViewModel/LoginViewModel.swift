//
//  LoginViewModel.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import Foundation
import FirebaseAuth

protocol ViewModelProtocol: ObservableObject {
	var loading: Bool { get }
	var showError: Bool { get }
	var errorMessage: String { get }
}

class LoginViewModel: ViewModelProtocol {
	
	@Published var phoneNumber: String = String()
	@Published var verificationId: String = String()
	@Published var otpText: String = String()
	@Published var otpSent: Bool = false
	
	@Published var loading: Bool = false
	@Published var showError: Bool = false
	@Published var errorMessage: String = String() {
		didSet {
			if errorMessage.isNotEmpty {
				print("Error: => \(errorMessage)")
				showError = true
			}
		}
	}

}

@MainActor
extension LoginViewModel {
	
	static func retriveUser() async {
		do {
			try await Auth.auth().currentUser?.reload()
		} catch { 
			let errorCode: Int = (error as NSError).code
			if errorCode == AuthErrorCode.userNotFound.rawValue
				|| errorCode == AuthErrorCode.userTokenExpired.rawValue {
				ProfileViewModel.logout()
			}
			print("\(#function) error: \(error.localizedDescription)")
		}
	}
	
	func sendOTP() async -> Bool {
		guard phoneNumber.count == 10 else {
			errorMessage = "Please enter valid mobile number"
			return false
		}
		defer { loading = false }
		loading = true
		verificationId = String()
		
		do {
			let response = try await PhoneAuthProvider.provider().verifyPhoneNumber("+91\(phoneNumber)")
			verificationId = response
			otpSent = true
		} catch {
			errorMessage = error.localizedDescription
			otpSent = false
		}
		
		return otpSent
	}
	
	func verifyOTP() async -> User? {
		let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otpText)
		
		defer { loading = false }
		loading = true
		do {
			let response = try await Auth.auth().signIn(with: credentials)
			return response.user
		} catch {
			errorMessage = error.localizedDescription
		}
		return .none
	}
}
