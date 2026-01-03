

# 🌍 GlobeTrotter – Personalized Travel Planning App

I have hosted the backend using Docker CI/CD in my own server with this link
     https://uaterp.skillhiveinnovations.com/api

GlobeTrotter is a **personalized, intelligent travel planning application** that helps users design, organize, and visualize multi-city trips with ease.
It focuses on **planning intelligence** rather than bookings, making travel planning as exciting as the journey itself.

Built as part of a **hackathon**, the project demonstrates **clean architecture, scalable backend design, and a polished Flutter UI**.

---

## 🚀 Key Features

* 🔐 User Authentication (Login & Signup)
* 🏠 Dashboard with upcoming trips & inspiration
* ✈️ Create and manage trips
* 🧱 Multi-city itinerary builder
* 🎯 Activity planning per city & day
* 💰 Budget estimation & breakdown
* 📆 Timeline & calendar views
* 🌐 Shareable read-only itineraries
* 🎨 Modern Flutter UI with real travel images

---

## 🧠 Problem We Solve

Travel planning today is:

* Fragmented across multiple apps
* Hard to manage for multi-city trips
* Budget-opaque
* Poorly visualized

**GlobeTrotter solves this by providing a single, structured, and visual platform for end-to-end trip planning.**

---

## 🛠 Tech Stack

### 📱 Frontend

* Flutter (Material 3)
* Dart
* Riverpod / Provider (state management)
* cached_network_image
* fl_chart
* intl

### 🧩 Backend

* Node.js
* Express.js
* PostgreSQL
* Prisma ORM
* JWT Authentication
* Hosted API (Cloud)

### 🌐 Backend Base URL

```
https://uaterp.skillhiveinnovations.com/api
```

---

## 🏗️ System Architecture

### 🔹 High-Level Architecture

```
┌──────────────┐
│   Flutter    │
│   Mobile UI  │
│              │
│  (Material3) │
└──────┬───────┘
       │ REST API (JSON)
       ▼
┌──────────────┐
│  Express.js  │
│   Backend    │
│              │
│ Auth | Trips │
│ Budget |     │
│ Itinerary    │
└──────┬───────┘
       │ Prisma ORM
       ▼
┌──────────────┐
│ PostgreSQL   │
│              │
│ Master Data  │
│ Users        │
│ Trips        │
│ Activities   │
│ Expenses     │
└──────────────┘
```

---

## 🧱 Backend Architecture (Layered)

```
Routes
  ↓
Controllers
  ↓
Services (Business Logic)
  ↓
Prisma ORM
  ↓
PostgreSQL
```

This separation ensures:

* Clean code
* Easy testing
* Scalability
* Maintainability

---

## 🗃️ Database Design Overview

### 🔹 Master Data

* City
* Activity
* Activity Category
* Cost Reference
* Currency

### 🔹 Transactional Data

* User
* Trip
* TripStop (City Stops)
* Activity Instance
* Expense
* Shared Trips

**Master data is separated from user data to maintain normalization and scalability.**

---

## 📱 Frontend Flow (Implemented)

```
Login / Signup
     ↓
Dashboard
     ↓
Create Trip
     ↓
My Trips
     ↓
Itinerary Builder
     ↓
Budget View
     ↓
Timeline / Calendar
     ↓
Share Trip (Read-Only)
```

---

## 🧪 Mock Data Strategy (UI First)

For rapid development and demo readiness:

* UI was first implemented using **mock data**
* Real images sourced from **Pexels**
* All mock models match backend API contracts
* Easy swap from mock → live API

This ensured:

* Faster UI iteration
* Stable demos
* Backend-ready frontend

---

## 🖼️ Image Handling

* High-quality travel images from **Pexels**
* Cached using `cached_network_image`
* Fallback placeholders included
* Stable URLs (no random refresh issues)

---

## ⚙️ How to Run the Project

### 📱 Frontend (Flutter)

```bash
flutter pub get
flutter run
```

### 🧩 Backend (Already Hosted)

No local setup required for demo.
API is live and accessible.

---

## 🎤 Demo Talking Points (For Judges)

* “This is a full end-to-end travel planning system.”
* “Backend is live and hosted on cloud.”
* “Frontend is built in Flutter with a scalable architecture.”
* “We focused on planning intelligence, not bookings.”
* “Master data and transactional data are cleanly separated.”

---

## 🧭 Future Enhancements

* AI-based itinerary recommendations
* Real cost APIs
* Collaborative trip planning
* Offline mode
* Multi-currency support
* Web version (Next.js)

---

## 👨‍💻 Team & Contribution

* Backend: API, DB design, Prisma
* Frontend: Flutter UI, UX, mock flow
* Architecture & Product: End-to-end system design

---

## 🏁 Conclusion

**GlobeTrotter** is not just a hackathon project — it is a **scalable product foundation** for intelligent travel planning.

---

If you want, next I can:

* 📊 Add **ER diagram**
* 🎨 Add **UI screenshots section**
* 🧪 Add **API documentation**
* 🧑‍⚖️ Rewrite README in **judge-friendly pitch style**

Just say the word, bro 👊
