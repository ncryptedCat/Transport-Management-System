# 🚍 Transport Management System (TMS)

A comprehensive smart transportation management solution designed for educational institutions. This project leverages **Flutter** for cross-platform mobile and web apps and **Firebase** (Firestore + Hosting) for scalable, real-time backend infrastructure. The system improves student safety, bus monitoring, and emergency response through **barcode-based student authentication**, **live GPS tracking**, and **offline sync support**.

---

## Core Features

- **Barcode-based Student Authentication**  
  Each student’s ID card includes a barcode that is scanned during boarding to verify identity against a secure Firestore database.

- **Real-Time Bus Tracking with Geo-Fencing**  
  Live location updates every 30 seconds, route monitoring with alerts if the bus deviates more than 500 meters from its assigned path.

- **Emergency SOS System**  
  Mobile app allows students to send GPS-tagged SOS alerts to campus security—even when offline.

- **Offline-First Functionality**  
  All modules support offline mode with Firestore’s data caching, syncing automatically when connectivity returns.

- **Flutter Web Admin Dashboard**  
  Centralized platform for admins to monitor all buses, student boarding, geo-fencing alerts, and feedback.

- **Student Feedback System**  
  App-integrated module to gather student feedback on transport quality and issues.

---

## Tech Stack

| Layer             | Technology                      |
|------------------|----------------------------------|
| Frontend (Mobile)| Flutter (Android & iOS)          |
| Frontend (Web)   | Flutter Web                      |
| Backend/Database | Firebase Firestore (NoSQL)       |
| Hosting          | Firebase Hosting                 |
| Real-time Data   | Firestore + WebSockets           |
| Sync             | Firestore Offline Mode           |
| Emergency Alerts | Twilio API (SMS fallback)        |

---

## Documentation

- [Project Report (PDF)](documentation/TMS_Project_Report.pdf)

---

## Testing Metrics

| Metric                 | Result                       |
|------------------------|------------------------------|
| Barcode Scan Accuracy  | 98%                          |
| Geo-Fencing Accuracy   | 97%                          |
| SOS Response Time      | <5s (Online), <10s (Offline) |
| User Satisfaction      | 90%                          |
| Offline Data Integrity | 100%                         |

---

## Future Enhancements
AI-based route optimization

Multi-campus expansion with Dockerized deployment

Predictive attendance and anomaly detection

Smart City Integration via Open APIs

---

## Contributors
N Vivek Reddy (ncryptedcat@gmail.com)

N Sai Achyuth

P Varshith

Guided by Mr. M. Sankara Mahalingam, Assistant Professor, Kalasalingam Academy of Research and Education.

---

## 📜 License

This project is intended **solely for academic and research purposes**.  
For **commercial use, licensing, or deployment**, please contact the contributors.

> **Note:** This project is associated with a filed/published patent.  
> Unauthorized commercial use may **infringe intellectual property rights** and is **strictly prohibited**.

