<?php
include 'db.php';

$email = $_POST['email'];
$password = $_POST['password'];

$sql = "SELECT * FROM users WHERE email = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    if (password_verify($password, $row['password'])) {
        echo json_encode(array("status" => 1, "msg" => "Login successful", "level" => $row['level']));
    } else {
        echo json_encode(array("status" => 0, "msg" => "Invalid password"));
    }
} else {
    echo json_encode(array("status" => 0, "msg" => "User not found"));
}

$conn->close();
?>
