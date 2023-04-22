//
//  ContentView.swift
//  wallpaperBG
//
//  Created by Staturnz on 4/21/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var coolStuff = false
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)

            Text("yo,\nso true frfr")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 8, x: 0, y: 0)
        }
        
        // just add bit below for the magic
        .withHostingWindow { window in
            if let controller = window?.rootViewController {
                controller.view.backgroundColor = .clear
                controller.view.isOpaque = false
            }
        }
    }
}

// for no bg hax
extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

// for blur
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

// for no bg hax
struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
