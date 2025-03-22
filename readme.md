# 🏥 MedNote - Medical Staff Note App

## Overview
**MedNote** is a **note-taking application** tailored for **medical staff** in hospitals and clinics, particularly for nurses and other personnel who need to **sync tasks, share updates, and maintain structured communication**. Each staff member can log in with their **clinical account** (validated by the backend based on the domain) and can perform CRUD operations on notes.

**Key Functionalities:**
- ✅ Secure login using **JWT authentication**
- ✅ **Role-based access** (superiors can view subordinate notes)
- ✅ **Create, update, delete, and share notes**
- ✅ Real-time synchronization of tasks

## 🛠️ Tech Stack
### **Frontend** (📱 Flutter)
- Flutter (Dart)
- Provider (State Management)
- REST API calls (HTTP)
- JWT Authentication

### **Backend** (🚀 Express.js)
- Node.js & Express.js
- MongoDB (Mongoose ORM)
- JWT Authentication

## 📂 Project Structure
```
MedNote/
│── frontend(flutter)/  # Flutter mobile app
│── backend(node_js_express)/  # Node.js Express backend
│── .gitignore  # Ignore unnecessary files
│── README.md  # Project documentation
```

## 🛠️ Installation & Setup
### 1️⃣ Clone the Repository
```bash
git clone https://github.com/your-username/MedNote.git
cd MedNote
```

### 2️⃣ Backend Setup (Node.js + Express.js)
```bash
cd backend(node_js_express)
npm install 
```
#### 🔐 Configure Environment Variables (.env)
In the `.env` file in the **backend(node_js_express)** folder and add:
```env
PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
```
#### 🚀 Run the Backend Server
```bash
npm start  # Start backend server
```

### 3️⃣ Frontend Setup (Flutter)
```bash
cd ../frontend(flutter)
flutter pub get  # Install dependencies
```
#### 🚀 Run the Flutter App
```bash
flutter run
```

## 🚀 API Endpoints (Backend)
### 🟢 **Authentication**
| Method | Endpoint       | Description |
|--------|--------------|-------------|
| POST   | /api/auth/login | Authenticate a user and return JWT |
| POST   | /api/auth/register | Register a new medical staff member |

### 📌 **Notes Management**
| Method | Endpoint        | Description |
|--------|----------------|-------------|
| POST   | /api/notes      | Create a new note |
| GET    | /api/notes      | Get all notes for the authenticated user |
| PUT    | /api/notes/:id  | Update a note |
| DELETE | /api/notes/:id  | Delete a note |

## 🛡️ Security & Authentication
- 🔐 **JWT Authentication** is used for login sessions.
- 🔐 **Role-based access control** (Superiors can view staff notes).
---

🚀 **Developed initially to meet a particular medical client's needs.**

💡 *Questions or Suggestions? contact!*

