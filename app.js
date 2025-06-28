const markdownEl = document.getElementById('markdown');
const previewEl = document.getElementById('preview');

// Update preview
function updatePreview() {
    const markdownText = markdownEl.value;
    previewEl.innerHTML = marked.parse(markdownText);
    document.querySelectorAll('pre code').forEach((block) => {
        hljs.highlightBlock(block);
    });
}

markdownEl.addEventListener('input', updatePreview);

// Electron integration
if (typeof window.electronAPI !== 'undefined') {
    // Handle file opened from Electron
    window.electronAPI.onFileOpened((data) => {
        markdownEl.value = data.content;
        updatePreview();
    });
    
    // Handle new file
    window.electronAPI.onNewFile(() => {
        markdownEl.value = '';
        updatePreview();
    });
    
    // Handle save
    window.electronAPI.onSaveFile(() => {
        window.electronAPI.saveContent(markdownEl.value);
    });
    
    // Handle save as
    window.electronAPI.onSaveFileAs(() => {
        window.electronAPI.saveContentAs(markdownEl.value);
    });
    
    // Override Cmd+S
    document.addEventListener('keydown', (e) => {
        if ((e.metaKey || e.ctrlKey) && e.key === 's') {
            e.preventDefault();
            if (e.shiftKey) {
                window.electronAPI.saveContentAs(markdownEl.value);
            } else {
                window.electronAPI.saveContent(markdownEl.value);
            }
        }
    });
} else {
    // Running in browser/PWA mode - register service worker
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/sw.js');
    }
}

// Initialize with some content if empty
if (!markdownEl.value) {
    markdownEl.value = `# Welcome to MadMD

Start typing your markdown here...

## Features
- **Live preview** as you type
- **Syntax highlighting** for code blocks
- **Native app** with full file system access

\`\`\`javascript
// Example code
console.log('Hello, MadMD!');
\`\`\`
`;
    updatePreview();
}
