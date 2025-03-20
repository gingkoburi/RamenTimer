import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioPlayerBGM: AVAudioPlayer?
    @State private var audioPlayerEffect: AVAudioPlayer?
    @State private var randomText: String = ""
    @State private var isTextVisible: Bool = false
    @State private var timeRemaining: Double = 0
    @State private var maxTime: Double = 0
    @State private var timer: Timer? = nil
    @State private var randomTextTimer: Timer? = nil
    @State private var isResetting: Bool = false
    //リセット中かどうかを追跡
    @State private var isShowingCredits : Bool = false

    var body: some View {
        ZStack {
            Image("24508882")
                .resizable(resizingMode: .tile)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button("RESET") {
                        resetTimer()
                        playSoundEffect(named: "075176_duck-quack-40345.mp3")
                        randomText = "RESET!"
                        isTextVisible = true
                        isResetting = true // リセット中を示すフラグを設定
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            if isResetting { // リセット中であればクリア
                                randomText = ""
                                isTextVisible = false
                            }
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .frame(width: 100, height: 35.0)
                    .cornerRadius(8)
                    .padding(.bottom, 2.0)
                    .padding(.trailing, 10)
                }
                Text("Ramen Timer")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 10)
                    .onTapGesture {
                        isShowingCredits = true
                    } .sheet(isPresented: $isShowingCredits) {
                        CreditView()
                    }
                Spacer()
            }
            ZStack {
                ProgressView(value: progressValue, total: 1.0)
                    .padding(.top, 450)
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 45)
                        .frame(width: 380, height: 380)
                        .foregroundColor(.white)
                        .opacity(0.9)
                        .shadow(radius: 10)
                    
                    Text(randomText)
                        .font(randomText == "DONE!!" ? .system(size: 40).bold() : .title)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                        .opacity(isTextVisible ? 1 : 0)
                        .animation(.easeIn(duration: 1.0), value: isTextVisible)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .padding(.bottom, 50)
            
            HStack {
                Spacer()
                Button("120") {
                    isResetting = false // リセット中フラグを解除
                    playSoundEffect(named: "buttonClick.mp3")
                    startTimer(duration: 120)
                    var quotes = Quotes()
                    randomText = quotes.getRandomText()
                    isTextVisible = true
                }
                .font(.system(size: 30))
                .frame(maxWidth: .infinity)
                .padding()
                .bold()
                .frame(width: 100, height: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
                Button("150") {
                    isResetting = false // リセット中フラグを解除
                    playSoundEffect(named: "buttonClick.mp3")
                    startTimer(duration: 150)
                    var quotes = Quotes()
                    randomText = quotes.getRandomText()
                    isTextVisible = true
                }
                .font(.system(size: 30))
                .padding()
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(1)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 100, height: 50)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
                Button("180") {
                    isResetting = false // リセット中フラグを解除
                    playSoundEffect(named: "buttonClick.mp3")
                    startTimer(duration: 180)
                    var quotes = Quotes()
                    randomText = quotes.getRandomText()
                    isTextVisible = true
                }
                .padding()
                .bold()
                .font(.system(size: 30))
                .frame(width: 100, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
            }
            .padding(.bottom, 30)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding()
        }
        .onAppear {
            playBackgroundMusic()
        }
    }
    
    private var progressValue: Double {
        if maxTime == 0 {
            return 0
        } else {
            return 1 - (timeRemaining / maxTime)
        }
    }
    
    private func startTimer(duration: Double) {
        maxTime = duration
        timeRemaining = duration
        
        timer?.invalidate()
        randomTextTimer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                randomTextTimer?.invalidate()
                playSoundEffect(named: "doneClick.mp3")
                randomText = "DONE!!"
                isTextVisible = true
            }
        }
        
        randomTextTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            var quotes = Quotes()
            randomText = quotes.getRandomText()
            isTextVisible = true
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        randomTextTimer?.invalidate()
        timeRemaining = 0
        randomText = ""
        isTextVisible = false
    }
    
    private func playSoundEffect(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: nil) else {
            print("Could not find the sound file.")
            return
        }
        
        do {
            // 効果音再生用のAVAudioPlayerを使用
            audioPlayerEffect = try AVAudioPlayer(contentsOf: url)
            audioPlayerEffect?.play()
        } catch {
            print("Could not load or play the sound file.")
        }
    }
    
    private func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "BGM", withExtension: "wav") else {
            print("音楽ファイルが見つかりません")
            return
        }

        do {
            print("AVAudioSessionを設定します")
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            print("音楽を再生します")
            audioPlayerBGM = try AVAudioPlayer(contentsOf: url)
            audioPlayerBGM?.numberOfLoops = -1
            audioPlayerBGM?.volume = 0.1
            audioPlayerBGM?.play()
            print("音楽が再生されました")
        } catch {
            print("音楽ファイルの再生に失敗しました: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
