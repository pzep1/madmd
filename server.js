const express = require('express');
const path = require('path');
const app = express();
const port = 8421;

app.use(express.static(path.join(__dirname, '/')));

app.listen(port, () => {
    console.log(`MadMD server listening at http://localhost:${port}`);
});