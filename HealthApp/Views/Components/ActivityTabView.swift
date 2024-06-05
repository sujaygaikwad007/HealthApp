
import SwiftUI

struct ActivityTabView: View {
    @EnvironmentObject var manager : HealthManager  
    @State var selectedTab  = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName:"house")
                }
                .environmentObject(manager)
            UserInfoView()
                .tag("Account")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

struct ActivityTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTabView()
    }
}
