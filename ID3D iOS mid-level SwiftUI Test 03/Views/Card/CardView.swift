//
//  CardView.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/20/21.
//

import Foundation
import SwiftUI
import SwiftUIPlus

struct CardView: View {
    
    // MARK: - View Model
    
    // MARK: - Environments
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - EnvironmentObjects
    
    // MARK: - StateObjects
    
    // MARK: - ObservedObjects
    
    // MARK: - States
    
    // MARK: - Bindings
    
    // MARK: - Properties
    let cardModel: CardModel
    
    // MARK: - Body
    var body: some View {
        ViewBody {
            content()
                .onAppear { didAppear() }
                .onDisappear { didDisappear() }
            
            navigationLinks()
        }
    }
}

// MARK: - Content
extension CardView {
    func content() -> some View {

        ZStack {
            NavigationStep(style: .view, type: .fullScreenSheet) {
                cardModel.destination
            } label: {
                ZStack {
                    Color.appBackgroundTertiary.cornerRadius(10).shadow(radius: 5)
                    VStack {
                        Text(cardModel.title)
                            .accessibility(identifier: "cardModel.title")
                            .foregroundColor(.appLabel)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                }
            }
        }
        .padding(20)
    }
}

// MARK: - Navigation Links
extension CardView {
    func navigationLinks() -> some View {
        Group {
            
        }
    }
}

// MARK: - Lifecycle
extension CardView {
    func didAppear() {
        
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension CardView {
    
}

// MARK: - Actions
extension CardView {
    func dismiss() {
        Navigation.dismiss(with: presentationMode)
    }
}

