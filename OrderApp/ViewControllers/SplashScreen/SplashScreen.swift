//
//  SplashScreen.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 17/09/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State var isScaled: Bool = true
    @State var showNextScreen: Bool = false
    var body: some View {
        ZStack {
            Color.snoonuBackground.ignoresSafeArea()
            VStack {
                Image(.snoonu)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(isScaled ? 0.75 : 1.3)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isScaled)
                    .onAppear {
                        isScaled.toggle()
                    }
                    .frame(maxHeight: .infinity)
                    .frame(alignment: .bottom)
                Spacer()
                ZStack {
                    Rectangle()
                        .frame(width: 280, height: 50)
                        .foregroundColor(.white)
                        .cornerRadius(20, corners: [ .topLeft,.topRight, .bottomRight])
                    VStack {
                        Text("Made in El-Mansoura with love ❤️")
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}


#Preview {
    SplashScreen()
}
