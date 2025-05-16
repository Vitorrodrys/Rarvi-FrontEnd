importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyA85f2siF2-7OhNrV7vZsckJzpA-STZN6o",
    authDomain: "rarvi-dcb61.firebaseapp.com",
    projectId: "rarvi-dcb61",
    storageBucket: "rarvi-dcb61.firebasestorage.app",
    messagingSenderId: "1099424508278",
    appId: "1:1099424508278:web:993dade85a66a7bfe33257",
    measurementId: "G-3ZK0HC0SDT"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});