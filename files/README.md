# Hackwave Havoc - Static Website

A cyberpunk/hacker-themed static website that was converted from a WordPress theme to pure HTML/CSS/JavaScript.

## 🚀 Quick Start

### Option 1: Python HTTP Server (Recommended)
```bash
# Navigate to the project directory
cd "Wormhole z90OW1"

# Run the Python server
python3 server.py
```

Then open your browser to: http://localhost:8000

### Option 2: Simple Python Server
```bash
# Navigate to the project directory
cd "Wormhole z90OW1"

# Run Python's built-in server
python3 -m http.server 8000
```

### Option 3: Any Static File Server
You can serve these files with any static file server like:
- nginx
- Apache
- Live Server (VS Code extension)
- Any web hosting service

## 📁 File Structure

```
Wormhole z90OW1/
├── index.html          # Main page (converted from index.php)
├── style.css           # All styling
├── script.js           # JavaScript functionality
├── server.py           # Python HTTP server
├── README.md           # This file
└── assets/
    ├── images/         # All website images
    └── videos/         # Background video
```

## 🎨 Features

- **Cyberpunk Aesthetic**: Neon green (#00ff00) and pink (#ff00ff) color scheme
- **Responsive Design**: Works on desktop and mobile devices
- **Interactive Elements**: 
  - Neon button effects with hover animations
  - Terminal typing effects
  - Animated equalizer canvas
  - Video autoplay with fallback
- **Grid Layout**: 20% | 60% | 20% column structure
- **Retro Fonts**: VT323 (terminal) and Press Start 2P (pixel)

## 🔧 What Was Removed

- All WordPress PHP dependencies
- WordPress theme functions
- WordPress header/footer includes
- WordPress-specific template tags

## 🎯 Navigation

The website has four main sections accessible via the neon buttons:
- **EVENTS** (green neon)
- **ABOUT US** (pink neon)
- **COMMUNITY** (green neon)
- **BLOG** (pink neon)

Currently, these buttons log to console. You can extend them by:
1. Creating separate HTML pages for each section
2. Adding navigation logic in `script.js`
3. Implementing a single-page application with JavaScript routing

## 🛠️ Development

To modify the website:
- Edit `index.html` for structure
- Edit `style.css` for styling
- Edit `script.js` for functionality
- Add new images to `assets/images/`
- Add new videos to `assets/videos/`

## 📱 Mobile Support

The website is fully responsive and includes mobile-specific styles for screens up to 768px width.

## 🎬 Video Requirements

The background video (`assets/videos/your-video.mp4`) should be:
- MP4 format
- Optimized for web (compressed)
- Ideally under 50MB for fast loading

## 🌐 Deployment

This static website can be deployed to any web hosting service:
- GitHub Pages
- Netlify
- Vercel
- AWS S3
- Any traditional web hosting

No server-side processing required! 