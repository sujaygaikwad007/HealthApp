import SwiftUI

struct ActivityCardView: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 0)
            
            VStack(alignment: .leading, spacing: 15) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 13))
                        Text(activity.subTitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }
                
                Text(activity.amount)
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.6)
            }
            .padding()
        }
       
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCardView(activity: Activity(id: 0, title: "Daily Steps", subTitle: "Goal: 10,000", image: "figure.walk", tintColor: .green, amount: "5,533"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
