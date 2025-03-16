<?php
session_start();
include 'database.php'; // Database connection file

if (!isset($_SESSION['admin_id'])) {
    header("Location: login.php");
    exit();
}

$admin_id = $_SESSION['admin_id'];
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
$conn->close();

if (!$admin) {
    die("Error: No admin found with this ID.");
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Info</title>
    <link rel="stylesheet" href="styles.css"> <!-- Ensure this matches your theme -->
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            background-color: #e9f5e9;
            color: #424242;
            width: 60px;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: width 0.3s;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .sidebar.expanded {
            width: 250px;
        }

        .sidebar h2 {
            color: #424242;
            font-size: 1.5rem;
            margin-bottom: 20px;
            display: none;
        }

        .sidebar.expanded h2 {
            display: block;
        }

        .sidebar a {
            color: #424242;
            text-decoration: none;
            padding: 15px;
            border-radius: 5px;
            margin: 5px 0;
            transition: background-color 0.3s;
            width: 100%;
            text-align: center;
            font-size: 1.1rem;
            display: none;
        }

        .sidebar.expanded a {
            display: block;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: #00796b;
            color: white;
        }

        .logout-btn {
            padding: 12px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            color: white;
            background-color: #00796b;
            transition: background-color 0.3s, transform 0.3s;
            width: 100%;
            text-align: center;
            margin-top: auto;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .logout-btn:hover {
            background-color: #004d40;
            transform: scale(1.05);
        }

        .container {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: white;
        }

        .header {
            background: #00796b;
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .admin-info {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .card {
            background: #f0f9ff;
            border: 1px solid #dbeafe;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }

        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin: 5px 0;
        }

        .btn-update, .btn-password, .btn-delete {
            background-color: #00796b;
            color: white;
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar" onclick="toggleSidebar()">
        <h2 id="sidebarTitle">Admin Panel</h2>
        <a href="dashboard.php" onclick="setActiveLink(this);">Dashboard</a>
        <a href="analytics.html" onclick="setActiveLink(this);">Analytics</a>
        <a href="admininfo.php" class="active">Admin Info</a>
        <button class="logout-btn" onclick="logout()">Logout</button>
    </div>

    <div class="container">
        <div class="header">Admin Info</div>
        <div class="admin-info">
            <h2>Admin Info</h2>
            <div class="card">
                <h3>Admin Details</h3>
                <p><b>Name:</b> <?php echo htmlspecialchars($admin['Name']); ?></p>
                <p><b>Email:</b> <?php echo htmlspecialchars($admin['Email']); ?></p>
                <p><b>Password:</b> *********</p>
            </div>

            <div class="card">
                <h3>Manage Account</h3>
                <form action="update.php" method="POST">
    <input type="hidden" name="update_request" value="1">
    <button type="submit" class="btn btn-update">Update Info</button>
</form>
 
 <form action="delete.php" method="POST">
        <button type="submit" class="btn btn-delete">Delete Account</button>
    </form>            </div>
        </div>
    </div>

    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('expanded');
            const sidebarTitle = document.getElementById('sidebarTitle');
            sidebarTitle.style.display = sidebar.classList.contains('expanded') ? 'block' : 'none';
        }

        function setActiveLink(link) {
            const links = document.querySelectorAll('.sidebar a');
            links.forEach((link) => link.classList.remove('active'));
            link.classList.add('active');
        }
        function logout() {
            // Display a confirmation prompt
    if (confirm("Are you sure you want to log out?")) {
        // Redirect to the logout.php page to handle session destruction
        window.location.href = "logout.php";
    } else {
        alert("Logout cancelled.");
    }
        }


        
    </script>
</body>
</html>
