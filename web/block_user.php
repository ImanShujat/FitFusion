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

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['id'])) {
    $userId = $_POST['id'];

    $statusQuery = "SELECT status FROM users WHERE id = ?";
    $stmt = $conn->prepare($statusQuery);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    $stmt->close();

    if ($user) {
        $newStatus = ($user['status'] == 'active') ? 'blocked' : 'active';

        $updateQuery = "UPDATE users SET status = ? WHERE id = ?";
        $stmt = $conn->prepare($updateQuery);
        $stmt->bind_param("si", $newStatus, $userId);

        if ($stmt->execute()) {
            echo $newStatus; // ✅ Correct Response
        } else {
            echo "error";
        }

        $stmt->close();
    } else {
        echo "user_not_found";
    }
}

$conn->close();
?>
