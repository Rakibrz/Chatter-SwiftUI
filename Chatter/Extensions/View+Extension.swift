//
//  View+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI
import FirebaseCore

extension View {
	
	func roundedCorner(radius: CGFloat = Constants.radius, border width: CGFloat = 1.5, color: Color? = nil) -> some View {
		background {
			RoundedRectangle(cornerRadius: radius)
			//                .strokeBorder(color ?? Color.theme.disabled, lineWidth: width) // Inside Borders
				.stroke(color ?? Color.theme.disabled, lineWidth: width)
		}
		.clipShape(RoundedRectangle(cornerRadius: radius))
	}
	
	/// apply to call only once
	func onFirstAppear(_ action: @escaping VoidCallback) -> some View {
		modifier(FirstAppearModifier(action: action))
	}
	
	/// Show Progress Loader animation
	func showLoader(when active: Bool) -> some View {
		modifier(ProgressLoaderModifier(active: active))
	}
	
	/// Show alert on the screen with dynamic action buttons
	func showAlert<Actions: View>(title: String = "Alert", message: String, when isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> Actions) -> some View {
		alert(title, isPresented: isPresented, actions: actions) { Text(message).font(.appFont(size: .medium)) }
	}
	
	/// Get safe area Insets of the device
	func getSafeArea() -> UIEdgeInsets {
		let safeArea = UIDevice.current.safeArea
		return safeArea
	}
	
	/// Hide view with condition
	func hide(when hide: Bool) -> some View {
		hide ? AnyView(hidden()) : AnyView(self)
	}
	
	/// Read the size of the specific view
	func readSize(onChange: @escaping ValueCallback<CGSize>) -> some View {
		background(
			GeometryReader { proxy in
				Color.clear
					.preference(key: SizePreferenceKey.self, value: proxy.size)
			}
		)
		.onPreferenceChange(SizePreferenceKey.self, perform: onChange)
	}
	
	/// Read the frame of the specific view
	func readFrame(coordinateSpace: CoordinateSpace = .global, onChange: @escaping ValueCallback<CGRect>) -> some View {
		background(
			GeometryReader { proxy in
				Color.clear
					.preference(key: FramePreferenceKey.self, value: proxy.frame(in: coordinateSpace))
			}
		)
		.onPreferenceChange(FramePreferenceKey.self, perform: onChange)
	}
	
	func applyDefaults() -> some View {
		tint(Color.accentColor)
			.hideDefaultNavigation()
			.environment(\.font, Font.custom("Barlow-Medium", size: 16))
	}
	
	/// Dismiss active keyboard from screen
	func dismissKeyboardOnTap(handler: VoidCallback? = nil) -> some View {
		onTapGesture {
			handler?()
			UIApplication.shared.endEditing()
		}
	}
	
}

// MARK: - Navigation bar
extension View {
	func appBar<Leading, Trailing>(title: String, tintColor: Color = Color.theme.lightOrange, leading: () -> Leading = { EmptyView() }, trailing: () -> Trailing = { EmptyView() }) -> some View where Leading: View, Trailing: View {
		hideDefaultNavigation()
			.safeAreaInset(edge: .top, spacing: AppPadding.small) {
				HStack(spacing: AppPadding.small) {
					if title.isNotEmpty {
						Text(title)
							.font(.appFont(size: .custom(value: 34)).weight(.bold))
							.frame(maxWidth: .infinity)
					}
				}
				.frame(maxWidth: .infinity)
				.overlay(alignment: .leading) {
					if leading() is EmptyView == false {
						leading()
					}
				}
				.overlay(alignment: .trailing) {
					if trailing() is EmptyView == false {
						trailing()
					}
				}
				.padding(.horizontal)
				.foregroundStyle(tintColor)
			}
		
	}
	
	func appNavigationBar<Leading, Trailing>(title: String,
											 leading: Leading? = Image(systemName: "chevron.backward").foregroundStyle(Color.appOrangeLight),
											 onLeadingTap: VoidCallback? = nil,
											 trailing: () -> Trailing? = { EmptyView() }) -> some View where Leading: View, Trailing: View {
		hideDefaultNavigation()
			.toolbar {
				if let leading, let onLeadingTap {
					ToolbarItem(placement: .topBarLeading) {
						Button(action: onLeadingTap, label: {
							leading
							
						})
					}
				}
				if title.isNotEmpty {
					ToolbarItem(placement: .principal) {
						Text(title)
							.foregroundStyle(Color.theme.lightOrange)
							.font(.appFont(size: .custom(value: 34)).weight(.bold))
					}
				}
				if (trailing() is EmptyView) == false {
					ToolbarItem(placement: .topBarTrailing) {
						trailing()
					}
				}
				
			}
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbar(.visible, for: .navigationBar)
			.toolbarRole(.navigationStack)
	}
	
	func hideDefaultNavigation() -> some View {
		navigationBarTitleDisplayMode(.inline)
		//			.navigationTitle
			.navigationBarBackButtonHidden()
			.toolbarBackground(.hidden, for: .navigationBar)
		
	}
	
	
}
