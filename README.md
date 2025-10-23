# 💓 Heartbeat Data Flow Visualization

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-17.0-brightgreen.svg)](https://developer.apple.com/ios/)
[![Framework](https://img.shields.io/badge/SwiftUI-Framework-blueviolet.svg)](https://developer.apple.com/xcode/swiftui/)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

**HeartbeatDataFlowView** is a real-time, data-driven biomedical visualization built entirely with **SwiftUI**.  
It simulates a dynamic ECG waveform synchronized with particle-based data flow, responsive lighting, and interactive metrics — merging **creative coding** with **medical-inspired motion design**.

---

## 🔹 Features

- **Live ECG waveform** with animated QRS, P, and T wave patterns  
- **Real-time heart dynamics**:
  - Adaptive heart rate (BPM)
  - Variable signal strength
  - Data points processed in real time
- **Particle system** simulating flowing biomedical data  
- **Pulse-synchronized visuals** with glowing gradients and soft shadows  
- **Interactive UI**: toggle live metrics (BPM, signal %, runtime, active particles)  
- **Fully animated SwiftUI environment** — no SceneKit or external frameworks required  

---

## 🎯 Key Components

- `HeartbeatDataFlowView`: The main SwiftUI container combining ECG visuals, metrics HUD, and background layers  
- `ECGWaveform`: Custom `Shape` reproducing realistic electrocardiogram curves with live amplitude & phase modulation  
- `MedicalBackground`: Layered gradient + motion system simulating a deep-tech medical UI aesthetic  
- `DataParticle` & `DataParticleView`: Animated biomedical data particles moving with the heartbeat flow  
- `VitalSignCard` & `DataMetricCard`: Responsive UI components displaying BPM, signal strength, and runtime metrics  

---

## 🎨 Design & Tech Stack

- **SwiftUI**: Declarative UI for complex animation composition  
- **Custom Shapes**: ECG waveform, diamond & hexagon particle geometries  
- **Canvas API**: Floating data particle rendering  
- **Animation System**: Real-time heartbeat pulses, easing functions, and dynamic glow  
- **Gradient & Shadow Effects**: Multi-layered lighting simulating biological energy flow  


## 🧠 Concept

This project blends **art, code, and biomedical inspiration** to visualize how physiological signals can be represented as data streams.  
It’s both a **creative experiment** and a **technical demonstration** of advanced SwiftUI animation, particle systems, and procedural waveform synthesis.

---

## 👩🏻‍💻 About me

Hi, I’m **Emilie (Em’)** 👋🏼  
I craft interactive experiences where **design meets data**, exploring the intersection of **SwiftUI**, **motion design**, and **creative visualization**.  
Passionate about transforming scientific and technical concepts into elegant, interactive stories.

- **Skills:** Swift, SwiftUI, UI/UX, Animation, Creative Coding  
- **Education:** Apple Foundation Program, Swift Certification  
- **Focus Areas:** Biomedical visualization, interface motion, and immersive app design  

---

## 📝 License

This project is open source under the **MIT License**.  
Feel free to explore, modify, and experiment with your own visualizations and data-driven art.

---

✨ Built with ❤️ by Emilie (Em’)
