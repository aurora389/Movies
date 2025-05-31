import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MoviesView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
        }
    }
}
