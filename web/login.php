<?php
// Start session
session_start();

// Include database connection
include 'database.php';

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get input values and trim spaces
    $email = trim($_POST['email']);
    $password = trim($_POST['password']);

    // Check if fields are empty
    if (empty($email) || empty($password)) {
        echo "<script>alert('Please fill in both email and password fields.'); window.location.href='login.html';</script>";
        exit;
    }

    // Use prepared statements to prevent SQL injection
    $stmt = $conn->prepare("SELECT ID, Name, Password FROM user WHERE Email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if user exists
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Verify password
        if (password_verify($password, $user['Password'])) {
            // Set session variables
            $_SESSION['admin_id'] = $user['ID'];  // Change `user_id` to `admin_id`
            $_SESSION['admin_name'] = $user['Name'];

            // Regenerate session ID for security
            session_regenerate_id(true);

            // Redirect to dashboard
            header("Location: dashboard.php");
            exit;
        } else {
            // Incorrect password
            $_SESSION['login_error'] = "Incorrect password. Try again.";
            header("Location: login.html");
            exit;
        }
    } else {
        // No user found
        $_SESSION['login_error'] = "No account found with this email. Please sign up first.";
        header("Location: signup.html");
        exit;
    }
    
    $stmt->close();
} else {
    echo "<script>alert('Invalid request method.'); window.location.href='login.html';</script>";
}
?>
