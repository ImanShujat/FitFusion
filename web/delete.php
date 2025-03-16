<?php
session_start();
$conn = new mysqli("localhost", "root", "", "admin");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Debugging: Check request method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    die("Invalid request method. Expected POST but got: " . $_SERVER['REQUEST_METHOD']);
}

// Check if admin is logged in
if (!isset($_SESSION['admin_id'])) {
    header("Location: login.php");
    exit();
}

$id = $_SESSION['admin_id'];
$stmt = $conn->prepare("DELETE FROM user WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    session_unset();
    session_destroy();
    header("Location: login.php");
    exit();
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
