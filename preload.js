const { contextBridge, ipcRenderer } = require('electron');

// Expose protected methods that allow the renderer process to use
// the ipcRenderer without exposing the entire object
contextBridge.exposeInMainWorld('electronAPI', {
  onFileOpened: (callback) => {
    ipcRenderer.on('file-opened', (event, data) => callback(data));
  },
  onNewFile: (callback) => {
    ipcRenderer.on('new-file', () => callback());
  },
  onSaveFile: (callback) => {
    ipcRenderer.on('save-file', () => callback());
  },
  onSaveFileAs: (callback) => {
    ipcRenderer.on('save-file-as', () => callback());
  },
  saveContent: (content) => {
    ipcRenderer.send('save-content', content);
  },
  saveContentAs: (content) => {
    ipcRenderer.send('save-content-as', content);
  }
});
