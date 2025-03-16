<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = "localhost";
$username_db = "root";
$password = "";
$database = "flutter";

$conn = new mysqli($host, $username_db, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Count active users
$activeQuery = "SELECT COUNT(*) AS active FROM users WHERE status = 'active'";
$activeResult = $conn->query($activeQuery);
$activeUsers = $activeResult->fetch_assoc()['active'];

// Count blocked users
$blockedQuery = "SELECT COUNT(*) AS blocked FROM users WHERE status = 'blocked'";
$blockedResult = $conn->query($blockedQuery);
$blockedUsers = $blockedResult->fetch_assoc()['blocked'];

$conn->close();

echo json_encode(["active" => $activeUsers, "blocked" => $blockedUsers]);
?>
