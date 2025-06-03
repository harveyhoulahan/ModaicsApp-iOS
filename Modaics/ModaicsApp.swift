//
//  ModaicsApp.swift
//  Modaics
//
//  Created by Harvey Houlahan on 3/6/2025.
//

import SwiftUI

// MARK: - Main Content View (Don't redeclare ModaicsApp here)
struct ContentView: View {
    @State private var currentStage: AppStage = .splash
    @State private var logoAnimationComplete = false
    @State private var contentReady = false
    @State private var userType: UserType?
    
    enum AppStage {
        case splash, login, transition, main
    }
    
    enum UserType {
        case user, brand
    }
    
    var body: some View {
        ZStack {
            switch currentStage {
            case .splash:
                SplashView(onAnimationComplete: {
                    logoAnimationComplete = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStage = .login
                        }
                    }
                })
                .transition(.opacity)
                
            case .login:
                LoginView(onUserSelect: { type in
                    userType = type
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStage = .transition
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        contentReady = true
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStage = .main
                        }
                    }
                })
                .transition(.opacity)
                
            case .transition:
                TransitionView(userType: userType, contentReady: contentReady)
                    .transition(.opacity)
                
            case .main:
                MainAppView(userType: userType ?? .user)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: currentStage)
    }
}

// MARK: - Splash Screen with Logo Animation
struct SplashView: View {
    let onAnimationComplete: () -> Void
    @State private var animationState: AnimationState = .initial
    @State private var leftDoorRotation: Double = 0
    @State private var rightDoorRotation: Double = 0
    @State private var contentOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 10
    
    enum AnimationState {
        case initial, animating, complete
    }
    
    var body: some View {
        ZStack {
            // Background - More sophisticated gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.15, blue: 0.2),
                    Color(red: 0.15, green: 0.2, blue: 0.3),
                    Color(red: 0.2, green: 0.25, blue: 0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Logo Animation - Much more sophisticated
                ZStack {
                    // Cotton-inspired background pattern
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .opacity(contentOpacity)
                    
                    // Chrome/metallic wardrobe doors
                    ZStack {
                        // Left door - chrome finish
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.7, green: 0.75, blue: 0.8),
                                        Color(red: 0.5, green: 0.55, blue: 0.65),
                                        Color(red: 0.6, green: 0.65, blue: 0.75)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 120)
                            .overlay(
                                // Cotton texture pattern
                                VStack(spacing: 4) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 25, height: 2)
                                    }
                                }
                                .opacity(contentOpacity)
                            )
                            .overlay(
                                // Chrome handle
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white, Color.gray.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 8, height: 8)
                                    .offset(x: 12, y: 0)
                            )
                            .rotationEffect(.degrees(leftDoorRotation), anchor: .leading)
                            .offset(x: -50, y: 0)
                        
                        // Middle section - denim blue
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.2, green: 0.4, blue: 0.7),
                                        Color(red: 0.15, green: 0.3, blue: 0.6)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 40, height: 120)
                            .overlay(
                                // Cotton items inside
                                VStack(spacing: 6) {
                                    ForEach(0..<5, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: 28, height: 4)
                                            .offset(x: CGFloat.random(in: -2...2))
                                    }
                                }
                                .opacity(contentOpacity)
                            )
                        
                        // Right door - chrome finish
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.6, green: 0.65, blue: 0.75),
                                        Color(red: 0.5, green: 0.55, blue: 0.65),
                                        Color(red: 0.7, green: 0.75, blue: 0.8)
                                    ],
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                )
                            )
                            .frame(width: 40, height: 120)
                            .overlay(
                                // Cotton texture pattern
                                VStack(spacing: 4) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 25, height: 2)
                                    }
                                }
                                .opacity(contentOpacity)
                            )
                            .overlay(
                                // Chrome handle
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white, Color.gray.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 8, height: 8)
                                    .offset(x: -12, y: 0)
                            )
                            .rotationEffect(.degrees(rightDoorRotation), anchor: .trailing)
                            .offset(x: 50, y: 0)
                    }
                    
                    // Chrome reflection effect
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 100, height: 4)
                        .offset(y: -50)
                        .opacity(textOpacity)
                }
                .frame(height: 140)
                
                // Logo text - more premium typography
                VStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Text("m")
                            .font(.system(size: 56, weight: .light, design: .serif))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.7, green: 0.75, blue: 0.8),
                                        Color(red: 0.5, green: 0.55, blue: 0.65)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("odaics")
                            .font(.system(size: 56, weight: .light, design: .serif))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.7, green: 0.75, blue: 0.8),
                                        Color(red: 0.5, green: 0.55, blue: 0.65)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    Text("A digital wardrobe for sustainable fashion")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity * 0.9)
                    
                    // Cotton farm heritage subtitle
                    Text("Born from Australian cotton farms")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.7, green: 0.75, blue: 0.8))
                        .opacity(textOpacity * 0.7)
                }
                .opacity(textOpacity)
                .offset(y: textOffset)
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animationState = .animating
            
            // Use more sophisticated spring animations
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8, blendDuration: 0.1)) {
                leftDoorRotation = -45
                rightDoorRotation = 45
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.1).delay(0.6)) {
                contentOpacity = 1
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.9, blendDuration: 0.1).delay(0.8)) {
                textOpacity = 1
                textOffset = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                animationState = .complete
                onAnimationComplete()
            }
        }
    }
}

// MARK: - Login Screen
struct LoginView: View {
    let onUserSelect: (ContentView.UserType) -> Void
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 20
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    // Simplified logo (open state)
                    ZStack {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 25)
                            .rotationEffect(.degrees(-40), anchor: .topLeading)
                            .offset(x: -8, y: 0)
                        
                        Rectangle()
                            .fill(Color.blue.opacity(0.9))
                            .frame(width: 8, height: 25)
                        
                        Rectangle()
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 8, height: 25)
                            .rotationEffect(.degrees(40), anchor: .topTrailing)
                            .offset(x: 8, y: 0)
                    }
                    .frame(width: 30, height: 30)
                    
                    Text("modaics")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 40) {
                    // Welcome content
                    VStack(spacing: 20) {
                        Text("Welcome to your digital wardrobe")
                            .font(.system(size: 32, weight: .light))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Modaics helps you discover, swap, and sell fashion items while reducing your environmental footprint.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Features
                    VStack(spacing: 25) {
                        FeatureRow(
                            icon: "checkmark.circle.fill",
                            title: "Verified Sustainability",
                            description: "Track your environmental impact with FibreTrace technology"
                        )
                        
                        FeatureRow(
                            icon: "person.2.fill",
                            title: "Community-Driven",
                            description: "Connect with like-minded fashion enthusiasts locally"
                        )
                        
                        FeatureRow(
                            icon: "lightbulb.fill",
                            title: "AI-Powered Styling",
                            description: "Get personalized recommendations that match your style"
                        )
                    }
                    .padding(.horizontal)
                }
                .opacity(contentOpacity)
                .offset(y: contentOffset)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    Button(action: { onUserSelect(.user) }) {
                        Text("Continue as User")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button(action: { onUserSelect(.brand) }) {
                        Text("Continue as Brand")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    Text("By continuing, you agree to our Terms and Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                contentOpacity = 1
                contentOffset = 0
            }
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Transition Screen
struct TransitionView: View {
    let userType: ContentView.UserType?
    let contentReady: Bool
    @State private var animationPhase: TransitionPhase = .initial
    @State private var wardrobeScale: CGFloat = 1
    @State private var wardrobeOpacity: Double = 1
    @State private var leftDoorRotation: Double = -40
    @State private var rightDoorRotation: Double = 40
    @State private var contentOpacity: Double = 0.7
    @State private var loadingOpacity: Double = 0
    
    enum TransitionPhase {
        case initial, expanding
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Expanding wardrobe
                ZStack {
                    // Left door
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: 30, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .rotationEffect(.degrees(leftDoorRotation), anchor: .topLeading)
                        .offset(x: -40, y: 0)
                    
                    // Middle section with content
                    Rectangle()
                        .fill(Color.blue.opacity(0.9))
                        .frame(width: 30, height: 100)
                        .overlay(
                            VStack(spacing: 6) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Rectangle()
                                        .fill(userType == .brand ? Color.blue.opacity(0.3) : Color.gray.opacity(0.6))
                                        .frame(width: 20, height: userType == .brand ? 6 : 4)
                                        .clipShape(RoundedRectangle(cornerRadius: 2))
                                }
                            }
                            .opacity(contentOpacity)
                        )
                    
                    // Right door
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: 30, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .rotationEffect(.degrees(rightDoorRotation), anchor: .topTrailing)
                        .offset(x: 40, y: 0)
                }
                .scaleEffect(wardrobeScale)
                .opacity(wardrobeOpacity)
                
                // Loading text and indicator
                VStack(spacing: 20) {
                    Text(userType == .user ? "Preparing your wardrobe..." : "Setting up your brand dashboard...")
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(1.0)
                                .animation(
                                    Animation.easeInOut(duration: 1.0)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: loadingOpacity
                                )
                        }
                    }
                }
                .opacity(loadingOpacity)
            }
        }
        .onAppear {
            startTransition()
        }
        .onChange(of: contentReady) { _, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.5)) {
                    loadingOpacity = 0
                    wardrobeOpacity = 0
                }
            }
        }
    }
    
    private func startTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animationPhase = .expanding
            
            withAnimation(.easeInOut(duration: 1.2)) {
                leftDoorRotation = -70
                rightDoorRotation = 70
                wardrobeScale = 1.3
            }
            
            withAnimation(.easeInOut(duration: 1.2)) {
                contentOpacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
                loadingOpacity = 1
            }
        }
    }
}

// MARK: - Main App View
struct MainAppView: View {
    let userType: ContentView.UserType
    @State private var selectedTab = 0
    @State private var contentOpacity: Double = 0
    @State private var contentScale: CGFloat = 0.95
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(userType: userType)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(1)
            
            SellView(userType: userType)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Sell")
                }
                .tag(2)
            
            CommunityView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Community")
                }
                .tag(3)
            
            ProfileView(userType: userType)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .scaleEffect(contentScale)
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                contentOpacity = 1
                contentScale = 1
            }
        }
    }
}

// MARK: - Tab Views
struct HomeView: View {
    let userType: ContentView.UserType
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with logo
                    HStack {
                        // Mini logo
                        ZStack {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 3, height: 12)
                                .rotationEffect(.degrees(-40), anchor: .topLeading)
                                .offset(x: -3, y: 0)
                            
                            Rectangle()
                                .fill(Color.blue.opacity(0.9))
                                .frame(width: 3, height: 12)
                            
                            Rectangle()
                                .fill(Color.blue.opacity(0.7))
                                .frame(width: 3, height: 12)
                                .rotationEffect(.degrees(40), anchor: .topTrailing)
                                .offset(x: 3, y: 0)
                        }
                        .frame(width: 15, height: 15)
                        
                        Text("modaics")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        // Header buttons
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .foregroundColor(.gray)
                            }
                            Button(action: {}) {
                                Image(systemName: "gearshape")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Text(userType == .user ? "Your Digital Wardrobe" : "Brand Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        Text(userType == .user ?
                             "Welcome to your sustainable fashion journey!" :
                             "Ready to showcase your sustainable collection?")
                            .font(.headline)
                        
                        Text(userType == .user ?
                             "Discover, swap, and add items to your digital wardrobe." :
                             "Manage your catalog, track sustainability metrics, and connect with conscious consumers.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(userType == .user ? "Get Started" : "View Analytics") {
                            // Action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        FeatureTile(
                            title: userType == .user ? "Discover Items" : "Manage Catalog",
                            icon: "magnifyingglass"
                        )
                        FeatureTile(
                            title: userType == .user ? "My Wardrobe" : "Brand Profile",
                            icon: "person.crop.rectangle"
                        )
                        FeatureTile(
                            title: "Sustainability Score",
                            icon: "leaf.fill"
                        )
                        FeatureTile(
                            title: userType == .user ? "Community" : "Customer Insights",
                            icon: "chart.bar.fill"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
    }
}

struct DiscoverView: View {
    var body: some View {
        NavigationView {
            Text("Discover")
                .font(.largeTitle)
                .navigationTitle("Discover")
        }
    }
}

struct SellView: View {
    let userType: ContentView.UserType
    
    var body: some View {
        NavigationView {
            Text(userType == .user ? "List & Sell" : "Brand Dashboard")
                .font(.largeTitle)
                .navigationTitle(userType == .user ? "Sell" : "Dashboard")
        }
    }
}

struct CommunityView: View {
    var body: some View {
        NavigationView {
            Text("Community")
                .font(.largeTitle)
                .navigationTitle("Community")
        }
    }
}

struct ProfileView: View {
    let userType: ContentView.UserType
    
    var body: some View {
        NavigationView {
            Text("Profile")
                .font(.largeTitle)
                .navigationTitle("Profile")
        }
    }
}

// MARK: - Feature Tile Component
struct FeatureTile: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2)
    }
}
