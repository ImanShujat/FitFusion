<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection
$host = "localhost";
$username_db = "root";
$password = "";
$database = "flutter";
$conn = new mysqli($host, $username_db, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to get signup data grouped by date
$sql_signup = "SELECT DATE(signup_datetime) AS signup_date, COUNT(*) AS user_count 
               FROM users 
               GROUP BY signup_date 
               ORDER BY signup_date";

$result_signup = $conn->query($sql_signup);

$signup_data = [];
if ($result_signup->num_rows > 0) {
    while ($row = $result_signup->fetch_assoc()) {
        $signup_data[] = $row;
    }
}

// Query to get active vs blocked users count
$sql_status = "SELECT status, COUNT(*) AS count FROM users GROUP BY status";

$result_status = $conn->query($sql_status);

$status_data = [];
if ($result_status->num_rows > 0) {
    while ($row = $result_status->fetch_assoc()) {
        $status_data[$row['status']] = $row['count'];
    }
}

// Combine both data
$response = [
    "signup_chart" => $signup_data,
    "status_chart" => $status_data
];

// Return data as JSON
echo json_encode($response);

// Close connection
$conn->close();
?>
