//
//  LoaderView.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

struct LoaderView: View {
	
	var thickness: CGFloat = 1 // default lineWidth
	@State private var isLoading: Bool = false
	
	var body: some View {
		ProgressView()
			.scaleEffect(.init(width: thickness, height: thickness))
		
		/*Circle()
			.strokeBorder(gradient, style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
			.rotationEffect(Angle(degrees: isLoading ? 360 : 0))
			.animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isLoading)
		 */
			.task {
				await MainActor.run {
					isLoading = true
				}
			}
		 
	}
	
	var gradient: AngularGradient {
		let stops: [Gradient.Stop] = [ Gradient.Stop(color: .white.opacity(0), location: .zero), Gradient.Stop(color: .white.opacity(0), location: 0.45), Gradient.Stop(color: .white, location: 1), ]
		return AngularGradient(stops: stops, center: .center) /* 3px for lineCap*/
		
		//        let colors: [Color] = [ .white.opacity(0.01), .white.opacity(0.5), .white ]
		//                AngularGradient(colors: colors, center: .center, startAngle: Angle.zero, endAngle: .degrees(360)) /*180 + 3px for lineCap*/
	}
	
}

#Preview {
	LoaderView()
}
