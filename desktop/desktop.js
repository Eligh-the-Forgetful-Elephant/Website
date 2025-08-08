// Cyberpunk Desktop JavaScript

let activeWindows = [];
let windowPositions = {};
let isDragging = false;
let dragOffset = { x: 0, y: 0 };

// Initialize desktop
document.addEventListener('DOMContentLoaded', function() {
    console.log('Cyberpunk Desktop v1.0 loaded');
    updateClock();
    setInterval(updateClock, 1000);
    
    // Add right-click context menu
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        showContextMenu(e.clientX, e.clientY);
    });
    
    // Close context menu on left click
    document.addEventListener('click', function() {
        hideContextMenu();
    });
    
    // Close start menu when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.start-button') && !e.target.closest('.start-menu')) {
            hideStartMenu();
        }
    });
});

// Window Management
function openWindow(windowId) {
    const window = document.getElementById(windowId + '-window');
    if (window) {
        // Set initial position if not set
        if (!windowPositions[windowId]) {
            windowPositions[windowId] = {
                x: Math.random() * (window.innerWidth - 400),
                y: Math.random() * (window.innerHeight - 300)
            };
        }
        
        window.style.left = windowPositions[windowId].x + 'px';
        window.style.top = windowPositions[windowId].y + 'px';
        window.style.width = '800px';
        window.style.height = '600px';
        
        window.classList.add('active', 'window-opening');
        activeWindows.push(windowId);
        
        // Add to taskbar
        addToTaskbar(windowId);
        
        // Remove animation class after animation
        setTimeout(() => {
            window.classList.remove('window-opening');
        }, 300);
        
        // Make window draggable
        makeWindowDraggable(window, windowId);
        
        console.log(`Opened window: ${windowId}`);
    }
}

function closeWindow(windowId) {
    const window = document.getElementById(windowId + '-window');
    if (window) {
        window.classList.remove('active');
        activeWindows = activeWindows.filter(id => id !== windowId);
        removeFromTaskbar(windowId);
        console.log(`Closed window: ${windowId}`);
    }
}

function minimizeWindow(windowId) {
    const window = document.getElementById(windowId + '-window');
    if (window) {
        window.classList.remove('active');
        console.log(`Minimized window: ${windowId}`);
    }
}

function maximizeWindow(windowId) {
    const window = document.getElementById(windowId + '-window');
    if (window) {
        if (window.style.width === '100vw' && window.style.height === '100vh') {
            // Restore
            window.style.width = '800px';
            window.style.height = '600px';
            window.style.left = windowPositions[windowId].x + 'px';
            window.style.top = windowPositions[windowId].y + 'px';
        } else {
            // Maximize
            window.style.width = '100vw';
            window.style.height = '100vh';
            window.style.left = '0px';
            window.style.top = '0px';
        }
        console.log(`Maximized window: ${windowId}`);
    }
}

// Make window draggable
function makeWindowDraggable(window, windowId) {
    const header = window.querySelector('.window-header');
    
    header.addEventListener('mousedown', function(e) {
        isDragging = true;
        const rect = window.getBoundingClientRect();
        dragOffset.x = e.clientX - rect.left;
        dragOffset.y = e.clientY - rect.top;
        
        window.style.cursor = 'grabbing';
    });
    
    document.addEventListener('mousemove', function(e) {
        if (isDragging) {
            const x = e.clientX - dragOffset.x;
            const y = e.clientY - dragOffset.y;
            
            window.style.left = x + 'px';
            window.style.top = y + 'px';
            
            // Update stored position
            windowPositions[windowId] = { x, y };
        }
    });
    
    document.addEventListener('mouseup', function() {
        isDragging = false;
        window.style.cursor = 'grab';
    });
}

// Taskbar Management
function addToTaskbar(windowId) {
    const taskbar = document.getElementById('taskbar-items');
    const taskbarItem = document.createElement('div');
    taskbarItem.className = 'taskbar-item';
    taskbarItem.textContent = getWindowTitle(windowId);
    taskbarItem.onclick = () => toggleWindow(windowId);
    taskbarItem.id = 'taskbar-' + windowId;
    taskbar.appendChild(taskbarItem);
}

function removeFromTaskbar(windowId) {
    const taskbarItem = document.getElementById('taskbar-' + windowId);
    if (taskbarItem) {
        taskbarItem.remove();
    }
}

function toggleWindow(windowId) {
    const window = document.getElementById(windowId + '-window');
    if (window.classList.contains('active')) {
        minimizeWindow(windowId);
    } else {
        openWindow(windowId);
    }
}

function getWindowTitle(windowId) {
    const titles = {
        'hackwave': 'Hackwave Havoc',
        'offensive': 'FOR THE LULZ',
        'blog': 'Blog',
        'terminal': 'Terminal',
        'files': 'File Explorer',
        'settings': 'Settings'
    };
    return titles[windowId] || windowId;
}

// Start Menu
function toggleStartMenu() {
    const startMenu = document.getElementById('start-menu');
    startMenu.classList.toggle('active');
}

function hideStartMenu() {
    const startMenu = document.getElementById('start-menu');
    startMenu.classList.remove('active');
}

// Context Menu
function showContextMenu(x, y) {
    const contextMenu = document.getElementById('context-menu');
    contextMenu.style.left = x + 'px';
    contextMenu.style.top = y + 'px';
    contextMenu.style.display = 'block';
}

function hideContextMenu() {
    const contextMenu = document.getElementById('context-menu');
    contextMenu.style.display = 'none';
}

// System Functions
function refreshDesktop() {
    location.reload();
}

function showSettings() {
    openWindow('settings');
}

function showAbout() {
    alert('Cyberpunk Desktop v1.0\n\nA virtual desktop environment for your projects.\n\nBuilt with HTML5, CSS3, and JavaScript.');
}

function showNotifications() {
    alert('🔔 Notifications\n\n• Hackwave Havoc: New community member joined\n• FOR THE LULZ: Demo mode active\n• Blog: New post published');
}

function showClock() {
    const now = new Date();
    alert(`🕐 System Time\n\n${now.toLocaleString()}\n\nCyberpunk Desktop v1.0`);
}

function showMusic() {
    alert('🎵 Music Player\n\n• Current Track: Techno Vibes - DJ Cyberpunk\n• Volume: 75%\n• Status: Playing');
}

function goBackHome() {
    console.log('goBackHome function called');
    // Close start menu first
    hideStartMenu();
    // Redirect to main index page
    console.log('Redirecting to main index...');
    try {
        window.location.href = '../index.html';
    } catch (error) {
        console.error('Navigation error:', error);
        // Fallback: try direct path
        window.location.href = '/index.html';
    }
}

function updateClock() {
    const now = new Date();
    const timeString = now.toLocaleTimeString();
    // You could update a clock element here if you add one
}

// Terminal Functions
function executeCommand(command) {
    const output = document.getElementById('terminal-output');
    const input = document.getElementById('terminal-input');
    
    switch(command.toLowerCase()) {
        case 'help':
            output.innerHTML = 'Available commands: help, clear, ls, about, hackwave, offensive, blog';
            break;
        case 'clear':
            output.innerHTML = '';
            break;
        case 'ls':
            output.innerHTML = 'hackwavehavoc/  for-the-lulz/  blog.html  desktop/  assets/';
            break;
        case 'about':
            output.innerHTML = 'Cyberpunk Desktop v1.0 - A virtual desktop environment';
            break;
        case 'hackwave':
            openWindow('hackwave');
            output.innerHTML = 'Opening Hackwave Havoc...';
            break;
        case 'offensive':
            openWindow('offensive');
            output.innerHTML = 'Opening FOR THE LULZ...';
            break;
        case 'blog':
            openWindow('blog');
            output.innerHTML = 'Opening Blog...';
            break;
        default:
            output.innerHTML = `Command not found: ${command}. Type 'help' for available commands.`;
    }
    
    input.textContent = '';
}

// Terminal input handling
document.addEventListener('keydown', function(e) {
    if (e.target.id === 'terminal-input') {
        if (e.key === 'Enter') {
            const command = e.target.textContent;
            executeCommand(command);
        }
    }
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Alt + Tab to cycle through windows
    if (e.altKey && e.key === 'Tab') {
        e.preventDefault();
        if (activeWindows.length > 0) {
            const currentIndex = activeWindows.indexOf(document.querySelector('.window.active')?.id.replace('-window', ''));
            const nextIndex = (currentIndex + 1) % activeWindows.length;
            openWindow(activeWindows[nextIndex]);
        }
    }
    
    // Escape to close start menu
    if (e.key === 'Escape') {
        hideStartMenu();
        hideContextMenu();
    }
});

// System tray functions
function showSystemTrayMenu() {
    alert('System Tray\n\n• Notifications: 3 new\n• Music: Playing\n• Clock: ' + new Date().toLocaleTimeString());
}

// Initialize some default windows
setTimeout(() => {
    console.log('Desktop ready. Type "help" in terminal for commands.');
}, 1000); 