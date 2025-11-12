const express = require('express');
const conexion = require('./config/database');
const cors = require('cors');
const app = express();
const rutaProductos = require('./routes/productRoutes.js');


app.use(cors());    
app.use(express.json()); // for parsing application/json
app.use(express.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded


app.use('/', rutaProductos);
app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
})