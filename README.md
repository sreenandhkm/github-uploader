# GitHub Uploader Web Application

A full-stack web application built using **Java** (Backend) and **HTML5/CSS/JavaScript** (Frontend) to easily upload files, directories, or code directly to any GitHub repository via the GitHub REST API.

## 🚀 Key Features

- **No external dependencies required**: Runs on standard Java (uses `com.sun.net.httpserver.HttpServer` and `java.net.http.HttpClient`). No Maven, Gradle, or Git CLI installations needed.
- **GitHub API Integration**: Direct communication with GitHub REST API (`v2022-11-28`) using a Personal Access Token (PAT).
- **Interactive Web UI**:
  - Step 1: Connect GitHub account with a Personal Access Token (with profile preview & badge).
  - Step 2: Select an existing repository from your account, or create a brand new repository directly from the UI.
  - Step 3: Drag & drop files, select entire folders (preserving folder hierarchy), or write/paste code directly in the browser.
  - Step 4: Batch upload files with real-time progress bar, status badges, and clickable links to the uploaded files and GitHub commit.
- **Create or Update**: Automatically checks if a file already exists on GitHub and attaches the file's latest `sha` so existing files are updated cleanly without conflict.
- **Binary & Text support**: Works with Java files, HTML, CSS, JS, Python, images, PDFs, ZIPs, and any arbitrary file type.

---

## 📁 Project Structure

```
github-uploader/
├── bin/                       # Compiled Java bytecode
├── src/
│   ├── GitHubUploaderServer.java  # Lightweight Java HTTP server & GitHub REST client
│   └── SimpleJson.java            # Pure Java JSON serializer & parser
├── web/
│   ├── index.html             # Web UI structure & controls
│   ├── styles.css             # GitHub-inspired dark theme UI styling
│   └── app.js                 # Frontend application logic & GitHub integration
├── run.bat                    # One-click Windows batch startup script
├── run.ps1                    # One-click PowerShell startup script
└── README.md                  # Documentation
```

---

## ⚡ How to Run

### Option 1: Double-click or run `run.bat`
```cmd
run.bat
```

### Option 2: Run via PowerShell
```powershell
.\run.ps1
```

### Option 3: Manual compilation and execution
```bash
# 1. Compile
javac -d bin src/*.java

# 2. Run
java -cp bin com.githubuploader.GitHubUploaderServer 8080
```

Once running, navigate to:
👉 **[http://localhost:8080](http://localhost:8080)**

---

## 🔑 How to get a GitHub Token

1. Go to [GitHub Tokens Settings](https://github.com/settings/tokens/new?scopes=repo&description=GitHub%20Uploader%20App).
2. Give your token a name (e.g. `GitHub Uploader`).
3. Ensure the **`repo`** permission checkbox is checked (enables full control of private/public repositories).
4. Click **Generate token** and copy the token (`ghp_...`).
5. Paste into Step 1 of the web application and click **Connect**!
