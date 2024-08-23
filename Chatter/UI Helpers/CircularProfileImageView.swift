//
//  CircularProfileImageView.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI
import NukeUI

struct CircularProfileImageView: View {
	let urlString: String?
	var size: ImageSize = .medium
	var fallbackImage: FallbackImage = .singleUser
		
    var body: some View {
		if let urlString, urlString.isNotEmpty {
			LazyImage(request: ImageRequest(url: URL(string: urlString), processors: [.resize(width: size.dimension)])) { state in
				if state.isLoading {
					ProgressView(value: Float(state.progress.completed), total: Float(state.progress.total))
						.progressViewStyle(.circular)
				}
				else if let image = state.image {
					image
						.resizable()
						.scaledToFill()
						.frame(width: size.dimension, height: size.dimension)
						.clipShape(.circle)
				}
				else if let error = state.error {
					Image(systemName: "exclamationmark.triangle")
						.resizable()
						.imageScale(.large)
						.scaledToFit()
						.frame(width: size.dimension / 3)
						.foregroundStyle(Color.red.gradient)
						.frame(width: size.dimension, height: size.dimension)
						.background(Color.init(white: 0.97).gradient)
						.clipShape(.circle)
						.onAppear {
							print("Image \(urlString) loading error ==> \(error.localizedDescription)")
						}
				}
			}
		} else {
			placeholderImageView()
		}
    }
}

private extension CircularProfileImageView {
	func placeholderImageView() -> some View {
		Image(systemName: fallbackImage.rawValue)
			.resizable()
			.imageScale(.large)
			.scaledToFit()
			.frame(width: size.dimension, height: size.dimension)
			.foregroundStyle(Color.gray.gradient)
//			.background(Color.gray.gradient)
			.clipShape(.circle)
	}
}

extension CircularProfileImageView {
	enum ImageSize {
		case xSmall, small, medium, large, xLarge
		case custom(CGFloat)
		
		var dimension: CGFloat {
			switch self {
			case .xSmall: 25
			case .small: 45
			case .medium: 60
			case .large: 85
			case .xLarge: 125
			case .custom(let size):
				size
			}
		}
	}
	
	enum FallbackImage: String {
		case singleUser = "person.circle.fill"
		case multiUser = "person.2.circle.fill"
	}
}

#Preview {
	VStack(spacing: 24) {
		CircularProfileImageView(urlString: String("https://picsum.photos/512"), size: .xLarge)
		CircularProfileImageView(urlString: String("https://picsm.photos/512"), size: .large)
		CircularProfileImageView(urlString: String(), fallbackImage: .multiUser)
	}
}
