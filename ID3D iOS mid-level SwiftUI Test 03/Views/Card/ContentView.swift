//
//  ContentView.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/14/21.
//

import CoreData
import SwiftUI
import SwiftUIPlus
import ZIPFoundation
//
//  ContentView.swift
//  ID3D
//
//  Created by Alex Nagy on 09.22.2021.
//

struct ContentView: View {
    
    // MARK: - View Model
    
    // MARK: - Environments
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - EnvironmentObjects
    
    // MARK: - StateObjects
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var alertManager = AlertManager()
    @StateObject private var progressHUDManager = ProgressHUDManager()
    
    // MARK: - ObservedObjects
    
    // MARK: - States
    @State private var isNeedToPublishCardViewPresented = false
    @State private var needToPublishCardViewTapLocation = CGPoint.zero
    
    
    // MARK: - Bindings
    
    // MARK: - Body
    var body: some View {
        ViewBody {
            ZStack {
                NavigationView {
                    content()
                }
            }.onAppear(perform: {
                viewModel.setObserver()
            })
            
            navigationLinks()
        }
    }
}

// MARK: - Content
extension ContentView {
    
    func content() -> some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    CardView(cardModel: CardModel(title: "Camera".localized, destination: CameraController().ignoresSafeArea().anyView()))
                        .accessibility(addTraits: .isButton)
                        .accessibility(identifier: "ContentView_CameraButton")
                    
                    if viewModel.isSessionAvailable {
                        Button("Zip Last Session") {
                            viewModel.isArhiving = true
                            viewModel.fetchAndZipLastSession()
                        }
                        .padding()
                        .background(Color.appButton)
                        .foregroundColor(Color.appLabelSecondary)
                        .clipShape(Capsule())
                    }
                    
                    if viewModel.isArhiving {
                        ProgressView("Archiving…",
                                     value: viewModel.archivedProgress,
                                     total: 1.0)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Navigation Links
extension ContentView {
    func navigationLinks() -> some View {
        Group {
            
        }
    }
}

// MARK: - Lifecycle
extension ContentView {
    func didAppear() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Navigation Bar
extension ContentView {
    func navigationBarTitleView() -> some View {
        EmptyView()
    }
    
    func navigationBarLeadingView() -> some View {
        EmptyView()
    }
    
    func navigationBarTrailingView() -> some View {
        EmptyView()
//        MenuButtonView()
    }
    
    func navigationBarBackgroundView() -> some View {
        VisualEffectView(effect: UIBlurEffect(style: .light)).ignoresSafeArea()
    }
}

// MARK: - Supplementary Views
extension ContentView {
    
}

// MARK: - Actions
extension ContentView {
    func dismiss() {
        Navigation.dismiss(with: presentationMode)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}


//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
