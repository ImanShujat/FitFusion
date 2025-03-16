<?php
include 'db.php';

$username = $_POST['username'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_BCRYPT);


$sql = "INSERT INTO users (username, email, password) VALUES ('$username', '$email', '$password')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(array("status" => 1, "msg" => "User registered successfully!"));
} else {
    echo json_encode(array("status" => 0, "msg" => "Error: " . $sql . "<br>" . $conn->error));
}

$conn->close();
?>
