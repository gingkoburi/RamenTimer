import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                ContentView() // メインコンテンツに遷移
            } else {
                VStack {
                    Image("Gradient Background, Motivating, Typographic Bookmark")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                    
                }
                .onAppear {
                    // スプラッシュスクリーン表示時間を2秒に設定
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
