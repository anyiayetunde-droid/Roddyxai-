# Claw App - AI Task Assistant for Android

Claw App is an installable Android application designed to bring the power of OpenClaw-like AI task automation directly to your smartphone. It features a clean chat interface and a built-in gateway manager.

## 🚀 How to Download and Install

**IMPORTANT**: Since I've just updated the app to fix the "Permission Denied" errors and integrated your Jules AI key, **you must download and install the new APK** for the changes to apply.

You can download the latest version directly from this repository:

1. **Go to the "Releases" Page**:
   - On the main page of this repository, look for the **"Releases"** section on the right-hand side (or click the "Releases" tab at the top).
2. **Download the APK**:
   - Click on the latest release (e.g., `v1`, `v2`).
   - Under the **"Assets"** section at the bottom of the release page, you will see **`app-debug.apk`**. Click it to download.
   - **Note**: If you don't see the APK yet, it might still be building. Check the **"Actions"** tab at the top of the repository to see the progress of the "Android CI" workflow.
3. **Install on Your Phone**:
   - Once the download is complete, open the APK file.
   - If prompted, allow your browser or file manager to **"Install from Unknown Sources"**.
   - Tap **"Install"** to complete the process.

## 🛠️ Usage

### Connecting the Assistant
- Open the Claw App on your phone.
- Tap the **Connection Icon** (🔗) in the top-right corner to start the OpenClaw Gateway.
- A green icon indicates you are connected and ready to chat.

### Chatting and Tasks
- Type your request in the message box at the bottom (e.g., "Summarize my latest notifications" or "Perform task X").
- Claw will process your request and respond directly in the chat.

## ℹ️ Technical Notes

- **Gateway Environment**: The app attempts to set up and run the OpenClaw gateway using a local shell script. For advanced features, it may require a Termux environment or specific system permissions.
- **Bionic Bypass**: The app includes automated patches (Bionic Bypass) to ensure compatibility with Android's system libraries.

## 🤝 Support

If you encounter any issues, please check the **"Issues"** tab in this repository or contribute to the project by submitting a Pull Request.

---
*Created with ❤️ by the Roddyx Team*
