import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var manager : HealthManager
    
    
    var body: some View {
        ZStack{
            Color.clear.ignoresSafeArea()
            
            VStack(alignment:.leading){
                welComeText
                mainContent
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .top)
            
        }
    }
}


extension HomeView{
    
    //Welcome Text
    private var welComeText : some View{
        Text("Welcome")
            .font(.largeTitle)
            .padding()
            .foregroundColor(Color.secondary)
        
    }
    
    private var mainContent : some View{
        
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
            
            ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }),
                    id: \.key){ item in
                
                ActivityCardView(activity: item.value)
            }
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HealthManager())
    }
}
