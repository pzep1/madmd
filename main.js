const { app, BrowserWindow, Menu, dialog, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow;
let currentFilePath = null;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    icon: path.join(__dirname, 'icons/icon.png'),
    titleBarStyle: 'hiddenInset',
    vibrancy: 'under-window',
    visualEffectState: 'active'
  });

  // Load the index.html file
  mainWindow.loadFile('index.html');

  // Open file if app was launched with one
  if (process.argv.length >= 2) {
    const filePath = process.argv[process.argv.length - 1];
    if (filePath.endsWith('.md') && fs.existsSync(filePath)) {
      openFile(filePath);
    }
  }
}

function openFile(filePath) {
  currentFilePath = filePath;
  const content = fs.readFileSync(filePath, 'utf8');
  const fileName = path.basename(filePath);
  
  mainWindow.webContents.send('file-opened', {
    content: content,
    path: filePath,
    name: fileName
  });
  
  mainWindow.setTitle(`${fileName} - MadMD`);
}

function saveFile(content) {
  if (!currentFilePath) {
    saveFileAs(content);
    return;
  }
  
  fs.writeFileSync(currentFilePath, content);
  mainWindow.setTitle(`${path.basename(currentFilePath)} - MadMD`);
}

function saveFileAs(content) {
  const result = dialog.showSaveDialogSync(mainWindow, {
    filters: [
      { name: 'Markdown', extensions: ['md'] },
      { name: 'All Files', extensions: ['*'] }
    ]
  });
  
  if (result) {
    currentFilePath = result;
    fs.writeFileSync(currentFilePath, content);
    mainWindow.setTitle(`${path.basename(currentFilePath)} - MadMD`);
  }
}

// Menu
function createMenu() {
  const template = [
    {
      label: 'File',
      submenu: [
        {
          label: 'New',
          accelerator: 'CmdOrCtrl+N',
          click: () => {
            currentFilePath = null;
            mainWindow.webContents.send('new-file');
            mainWindow.setTitle('Untitled - MadMD');
          }
        },
        {
          label: 'Open...',
          accelerator: 'CmdOrCtrl+O',
          click: () => {
            const result = dialog.showOpenDialogSync(mainWindow, {
              filters: [
                { name: 'Markdown', extensions: ['md'] },
                { name: 'All Files', extensions: ['*'] }
              ]
            });
            
            if (result && result[0]) {
              openFile(result[0]);
            }
          }
        },
        { type: 'separator' },
        {
          label: 'Save',
          accelerator: 'CmdOrCtrl+S',
          click: () => {
            mainWindow.webContents.send('save-file');
          }
        },
        {
          label: 'Save As...',
          accelerator: 'CmdOrCtrl+Shift+S',
          click: () => {
            mainWindow.webContents.send('save-file-as');
          }
        }
      ]
    },
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { role: 'selectAll' }
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
      ]
    }
  ];

  if (process.platform === 'darwin') {
    template.unshift({
      label: app.getName(),
      submenu: [
        { role: 'about' },
        { type: 'separator' },
        { role: 'services', submenu: [] },
        { type: 'separator' },
        { role: 'hide' },
        { role: 'hideOthers' },
        { role: 'unhide' },
        { type: 'separator' },
        { role: 'quit' }
      ]
    });
  }

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

// IPC handlers
ipcMain.on('save-content', (event, content) => {
  saveFile(content);
});

ipcMain.on('save-content-as', (event, content) => {
  saveFileAs(content);
});

// App event handlers
app.whenReady().then(() => {
  createWindow();
  createMenu();
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// Handle file open on macOS
app.on('open-file', (event, path) => {
  event.preventDefault();
  
  if (mainWindow) {
    openFile(path);
  } else {
    app.whenReady().then(() => {
      openFile(path);
    });
  }
});
