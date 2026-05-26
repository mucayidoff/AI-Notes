import SwiftUI
import AVFoundation

struct WelcomeView: View {
    @Binding var showLogin: Bool
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @State private var animate = false
    @State private var player: AVAudioPlayer?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: animate ? 140 : 100, height: animate ? 140 : 100)
                    .foregroundColor(.white)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)

                Text("AI Notes'a Hoş Geldin!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1 : 0.8)
                    .animation(.easeIn(duration: 1).delay(0.3), value: animate)

                Text("Notları keşfet, fikirleri büyüt!")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1 : 0.8)
                    .animation(.easeIn(duration: 1).delay(0.5), value: animate)

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animate = false
                    }
                    hasSeenWelcome = true  // 🔹 Artık tekrar gösterilmez
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showLogin = true
                    }
                }) {
                    Text("Başla 🚀")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                }
                .opacity(animate ? 1 : 0)
                .animation(.easeIn(duration: 1).delay(0.7), value: animate)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            animate = true
            playBackgroundMusic()
        }
    }

    func playBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "welcome_music", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
                player?.volume = 0.2
                player?.play()
            } catch {
                print("Müzik çalınamadı: \(error.localizedDescription)")
            }
        }
    }
}
