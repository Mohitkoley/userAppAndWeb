importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyA_bmwUlrOdffxegB9A16_D-EOZ2k04Sec",
  authDomain: "oley-shop.firebaseapp.com",
  projectId: "oley-shop",
  storageBucket: "oley-shop.firebasestorage.app",
  messagingSenderId: "977728681518",
  appId: "1:977728681518:web:89aaec07f7180f6d9f91bf",
  measurementId: "G-6V4W99CYB6"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});