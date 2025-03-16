<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection
$host = "localhost";
$username_db = "root";
$password = "";
$database = "flutter";

$conn = new mysqli($host, $username_db, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Debug: Check if ID is received
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['id'])) {
    $userId = $_POST['id'];

    // Debug: Print received ID
    echo "Received ID: " . $userId . "<br>";

    $deleteQuery = "DELETE FROM users WHERE id = ?";
    $stmt = $conn->prepare($deleteQuery);
    $stmt->bind_param("i", $userId);

    if ($stmt->execute()) {
        echo "User deleted successfully!";
    } else {
        echo "Error deleting user! " . $conn->error;
    }

    $stmt->close();
} else {
    echo "No user ID received!";
}

$conn->close();
?>
