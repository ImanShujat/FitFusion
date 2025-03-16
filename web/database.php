<?php
// Database connection configuration
$servername = "localhost";
$username = "root"; // Change this if your database username is different
$password = ""; // Leave blank if there is no password (for localhost)
$dbname = "admin"; // Name of the database

// Create a database connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>
