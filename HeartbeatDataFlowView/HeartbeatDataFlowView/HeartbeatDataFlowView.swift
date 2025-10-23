//
//  HeartbeatDataFlowView.swift
//  HeartbeatDataFlowView
//
//  Created by Emilie on 19/10/2025.
//
import SwiftUI

struct HeartbeatDataFlowView: View {
    @State private var heartbeatPhase: CGFloat = 0
    @State private var particles: [DataParticle] = []
    @State private var pulseWave: CGFloat = 0
    @State private var bpm: Int = 72
    @State private var dataProcessed: Int = 0
    @State private var signalStrength: CGFloat = 0.95
    @State private var showMetrics: Bool = true
    @State private var ecgAmplitude: CGFloat = 1.0
    @State private var timeElapsed: Int = 0
    
    let namespace = Namespace().wrappedValue
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Medical gradient background
                MedicalBackground(pulseWave: pulseWave, signalStrength: signalStrength)
                
                // Main ECG and particle system
                VStack(spacing: 0) {
                    Spacer()
                    
                    // ECG Visualization
                    ZStack {
                        // Background grid
                        ECGGrid()
                            .stroke(Color.cyan.opacity(0.15), lineWidth: 1)
                        
                        // Main ECG line
                        ECGWaveform(
                            phase: heartbeatPhase,
                            amplitude: ecgAmplitude,
                            pulseWave: pulseWave
                        )
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.cyan,
                                    Color.blue,
                                    Color.mint,
                                    Color.cyan
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                        )
                        .shadow(color: .cyan.opacity(0.8), radius: 8, x: 0, y: 0)
                        .shadow(color: .cyan.opacity(0.4), radius: 16, x: 0, y: 0)
                        
                        // Particles flowing with ECG
                        ForEach(particles) { particle in
                            DataParticleView(particle: particle, pulseWave: pulseWave)
                        }
                        
                        // Pulse origin point
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.red,
                                        Color.red.opacity(0.8),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(1.0 + sin(pulseWave * .pi * 2) * 0.3)
                            .position(x: geometry.size.width * 0.15, y: geometry.size.height / 2)
                            .blur(radius: 4)
                        
                        // Heart icon
                        Image(systemName: "heart.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.red, Color.pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(1.0 + sin(pulseWave * .pi * 2) * 0.2)
                            .position(x: geometry.size.width * 0.15, y: geometry.size.height / 2)
                            .shadow(color: .red.opacity(0.6), radius: 12, x: 0, y: 0)
                    }
                    .frame(height: 300)
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                
                // Medical HUD
                VStack {
                    if showMetrics {
                        HStack(spacing: 16) {
                            VitalSignCard(
                                icon: "waveform.path.ecg",
                                title: "Heart Rate",
                                value: "\(bpm)",
                                unit: "BPM",
                                color: .red,
                                isActive: true
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                            
                            VitalSignCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Signal",
                                value: String(format: "%.0f", signalStrength * 100),
                                unit: "%",
                                color: .cyan,
                                isActive: signalStrength > 0.9
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    // Toggle button
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showMetrics.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: showMetrics ? "eye.slash.fill" : "chart.xyaxis.line")
                                    .font(.system(size: 12, weight: .semibold))
                                Text(showMetrics ? "Hide Metrics" : "Show Metrics")
                                    .font(.system(size: 11, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.red.opacity(0.4), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 24)
                    }
                    .padding(.bottom, 12)
                    
                    if showMetrics {
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                DataMetricCard(
                                    icon: "circle.hexagongrid.fill",
                                    label: "Data Points",
                                    value: "\(dataProcessed)",
                                    color: .blue
                                )
                                
                                DataMetricCard(
                                    icon: "waveform",
                                    label: "Active Particles",
                                    value: "\(particles.filter { $0.isActive }.count)",
                                    color: .mint
                                )
                                
                                DataMetricCard(
                                    icon: "clock.fill",
                                    label: "Runtime",
                                    value: formatTime(timeElapsed),
                                    color: .purple
                                )
                            }
                            
                            Text("Biomedical Data Visualization • Real-time Analysis")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                                .textCase(.uppercase)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            updateAnimation()
        }
        .onAppear {
            startHeartbeat()
            startMetricsTracking()
        }
    }
    
    // MARK: - Animation Updates
    
    func updateAnimation() {
        heartbeatPhase += 0.02
        
        // Update particles
        for i in particles.indices {
            particles[i].position.x += particles[i].velocity.x
            particles[i].position.y += particles[i].velocity.y
            particles[i].opacity = max(0, particles[i].opacity - 0.008)
            particles[i].scale = max(0.1, particles[i].scale - 0.005)
            
            if particles[i].opacity <= 0 {
                particles[i].isActive = false
            }
        }
        
        // Remove inactive particles
        particles.removeAll { !$0.isActive }
        
        // Update signal strength with variation
        signalStrength = 0.92 + sin(heartbeatPhase * 3) * 0.05
    }
    
    func startHeartbeat() {
        // Main heartbeat timer
        Timer.scheduledTimer(withTimeInterval: 60.0 / Double(bpm), repeats: true) { _ in
            triggerHeartbeat()
        }
    }
    
    func triggerHeartbeat() {
        withAnimation(.easeOut(duration: 0.15)) {
            pulseWave = 1.0
            ecgAmplitude = 1.3
        }
        
        // Create particle burst
        createParticleBurst()
        
        // Reset pulse wave
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeIn(duration: 0.3)) {
                pulseWave = 0
                ecgAmplitude = 1.0
            }
        }
        
        // Vary BPM slightly
        withAnimation(.easeInOut(duration: 2.0)) {
            bpm = Int.random(in: 68...76)
        }
    }
    
    func createParticleBurst() {
        let count = Int.random(in: 15...25)
        
        for _ in 0..<count {
            let particle = DataParticle(
                position: CGPoint(x: 0.15, y: 0.5),
                velocity: CGPoint(
                    x: CGFloat.random(in: 0.003...0.008),
                    y: CGFloat.random(in: -0.002...0.002)
                ),
                size: CGFloat.random(in: 4...12),
                color: [Color.cyan, Color.blue, Color.mint, Color.purple].randomElement() ?? .cyan,
                type: DataParticleType.allCases.randomElement() ?? .circle
            )
            particles.append(particle)
        }
        
        dataProcessed += count
    }
    
    func startMetricsTracking() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeElapsed += 1
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Data Structures

struct DataParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var color: Color
    var type: DataParticleType
    var opacity: CGFloat = 1.0
    var scale: CGFloat = 1.0
    var isActive: Bool = true
}

enum DataParticleType: CaseIterable {
    case circle, square, diamond, hexagon
}

// MARK: - ECG Waveform Shape

struct ECGWaveform: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var pulseWave: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(phase, AnimatablePair(amplitude, pulseWave)) }
        set {
            phase = newValue.first
            amplitude = newValue.second.first
            pulseWave = newValue.second.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midY = height / 2
        
        let samples = 300
        
        for i in 0..<samples {
            let progress = CGFloat(i) / CGFloat(samples)
            let x = progress * width
            
            // Create ECG-like waveform
            var y = midY
            
            // Baseline with slight variation
            y += sin((progress - phase) * .pi * 8) * 3
            
            // P wave (small bump before QRS)
            let pWavePos = (progress - phase).truncatingRemainder(dividingBy: 1.0)
            if pWavePos > 0.2 && pWavePos < 0.3 {
                let pProgress = (pWavePos - 0.2) / 0.1
                y -= sin(pProgress * .pi) * 15 * amplitude
            }
            
            // QRS complex (main spike)
            if pWavePos > 0.35 && pWavePos < 0.5 {
                let qrsProgress = (pWavePos - 0.35) / 0.15
                
                // Q wave (small dip)
                if qrsProgress < 0.2 {
                    y += sin(qrsProgress * .pi * 5) * 8 * amplitude
                }
                // R wave (tall spike)
                else if qrsProgress < 0.6 {
                    let rProgress = (qrsProgress - 0.2) / 0.4
                    y -= sin(rProgress * .pi) * 80 * amplitude * (1.0 + pulseWave * 0.5)
                }
                // S wave (small dip)
                else {
                    let sProgress = (qrsProgress - 0.6) / 0.4
                    y += sin(sProgress * .pi) * 20 * amplitude
                }
            }
            
            // T wave (rounded bump after QRS)
            if pWavePos > 0.55 && pWavePos < 0.75 {
                let tProgress = (pWavePos - 0.55) / 0.2
                y -= sin(tProgress * .pi) * 25 * amplitude
            }
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

// MARK: - ECG Grid

struct ECGGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let spacing: CGFloat = 20
        
        // Vertical lines
        for x in stride(from: 0, through: rect.width, by: spacing) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        // Horizontal lines
        for y in stride(from: 0, through: rect.height, by: spacing) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

// MARK: - Particle View

struct DataParticleView: View {
    let particle: DataParticle
    let pulseWave: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let x = particle.position.x * geometry.size.width
            let y = particle.position.y * geometry.size.height
            
            ZStack {
                switch particle.type {
                case .circle:
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    particle.color.opacity(particle.opacity),
                                    particle.color.opacity(particle.opacity * 0.6),
                                    particle.color.opacity(particle.opacity * 0.2)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size
                            )
                        )
                case .square:
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            RadialGradient(
                                colors: [
                                    particle.color.opacity(particle.opacity),
                                    particle.color.opacity(particle.opacity * 0.6),
                                    particle.color.opacity(particle.opacity * 0.2)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size
                            )
                        )
                case .diamond:
                    DiamondShape()
                        .fill(
                            RadialGradient(
                                colors: [
                                    particle.color.opacity(particle.opacity),
                                    particle.color.opacity(particle.opacity * 0.6),
                                    particle.color.opacity(particle.opacity * 0.2)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size
                            )
                        )
                case .hexagon:
                    HexagonShape()
                        .fill(
                            RadialGradient(
                                colors: [
                                    particle.color.opacity(particle.opacity),
                                    particle.color.opacity(particle.opacity * 0.6),
                                    particle.color.opacity(particle.opacity * 0.2)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size
                            )
                        )
                }
            }
            .frame(width: particle.size * particle.scale, height: particle.size * particle.scale)
            .position(x: x, y: y)
            .blur(radius: 1)
            .shadow(color: particle.color.opacity(particle.opacity * 0.8), radius: 8, x: 0, y: 0)
        }
    }
}

// MARK: - Custom Shapes

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = (0..<6).map { i -> CGPoint in
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            return CGPoint(
                x: rect.midX + rect.width / 2 * cos(angle),
                y: rect.midY + rect.height / 2 * sin(angle)
            )
        }
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Background

struct MedicalBackground: View {
    let pulseWave: CGFloat
    let signalStrength: CGFloat
    @State private var particleOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Deep medical gradient
            LinearGradient(
                colors: [
                    Color(red: 0.01, green: 0.02, blue: 0.06),
                    Color(red: 0.02, green: 0.03, blue: 0.09),
                    Color(red: 0.03, green: 0.04, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Pulse wave overlay
            RadialGradient(
                colors: [
                    Color.red.opacity(Double(pulseWave * 0.15)),
                    Color.clear
                ],
                center: UnitPoint(x: 0.15, y: 0.5),
                startRadius: 0,
                endRadius: 500
            )
            
            // Floating data particles
            Canvas { context, size in
                for i in 0..<30 {
                    let x = (CGFloat(i) * size.width / 30 + particleOffset * 0.2).truncatingRemainder(dividingBy: size.width)
                    let y = (CGFloat(i * 19) + particleOffset + sin(CGFloat(i) * 0.4) * 40).truncatingRemainder(dividingBy: size.height)
                    let particleSize = 2.0 + signalStrength * 2.0
                    let opacity = signalStrength * 0.3 + 0.1
                    
                    context.fill(
                        Circle().path(in: CGRect(x: x, y: y, width: particleSize, height: particleSize)),
                        with: .color(.cyan.opacity(Double(opacity)))
                    )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                particleOffset = UIScreen.main.bounds.height
            }
        }
    }
}

// MARK: - UI Components

struct VitalSignCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
                .symbolEffect(.pulse, isActive: isActive)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                    
                    Text(unit)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.5), color.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: color.opacity(0.4), radius: 12, x: 0, y: 6)
    }
}

struct DataMetricCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HeartbeatDataFlowView()
}
