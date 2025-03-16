<?php
session_start();
include 'database.php'; // Database connection file

// Check if user is logged in
if (!isset($_SESSION['admin_id'])) {
    header("Location: login.php");
    exit();
}

$admin_id = $_SESSION['admin_id'];

// Fetch existing user data
$query = "SELECT Name, Email FROM user WHERE id = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    die("Database query failed: " . $conn->error);
}

$stmt->bind_param("i", $admin_id);
$stmt->execute();
$result = $stmt->get_result();
$admin = $result->fetch_assoc();
$stmt->close();

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (isset($_POST['name'], $_POST['email'])) {
        $new_name = trim($_POST['name']);
        $new_email = trim($_POST['email']);

        if (!empty($new_name) && !empty($new_email)) {
            $update_stmt = $conn->prepare("UPDATE user SET Name = ?, Email = ? WHERE id = ?");
            $update_stmt->bind_param("ssi", $new_name, $new_email, $admin_id);

            if ($update_stmt->execute()) {
                $_SESSION['name'] = $new_name;
                $_SESSION['email'] = $new_email;
                echo "<script>alert('Update successful!'); window.location.href='admininfo.php';</script>";
            } else {
                echo "Error updating record: " . $update_stmt->error;
            }
            $update_stmt->close();
        } else {
            echo "<script>alert('Fields cannot be empty!');</script>";
        }
    } else {
        echo "<script>alert('Invalid request!');</script>";
    }
}
$conn->close();
?>

<!-- HTML Form -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Admin Info</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        h2 {
            text-align: center;
            color: #00796B;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-top: 15px;
            background-color: #00796B;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #005f56;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Update Admin Info</h2>
        <form method="post">
            <label for="name">New Name:</label>
            <input type="text" name="name" value="<?php echo htmlspecialchars($admin['Name'], ENT_QUOTES, 'UTF-8'); ?>" required>
            
            <label for="email">New Email:</label>
            <input type="email" name="email" value="<?php echo htmlspecialchars($admin['Email'], ENT_QUOTES, 'UTF-8'); ?>" required>
            
            <input type="submit" value="Update">
        </form>
    </div>
</body>
</html>
