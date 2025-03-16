<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fitness App Admin Panel</title>
    <style>
        /* Your existing styles here */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            background-color: #e9f5e9; /* Green */
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
            text-align: center; /* Centered links */
            font-size: 1.1rem;
            display: none;
        }

        .sidebar.expanded a {
            display: block;
        }

        .sidebar a:hover {
            background-color: #00796b; /* Muted green */
    color: white; /* Ensure text is visible */
        }

        .sidebar a.active {
            background-color: #00796b; /* Highlight active link */
        }

        .logout-btn {
            padding: 12px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            color: #ffffff; /* White text color */
            background-color: #00796b; /* Brighter red */
            transition: background-color 0.3s, transform 0.3s; /* Add transition for hover effects */
            width: 100%;
            text-align: center;
            margin-top: auto;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Add shadow for depth */
        }

        .logout-btn:hover {
            background-color: #00796b; /* Darker red */
            transform: scale(1.05); /* Slight scaling effect on hover */
        }

        .container {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: white;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: center;
            background: #00796b; /* Gradient background */
            padding: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* More pronounced shadow */
            margin-bottom: 20px;
            border-radius: 8px; /* Rounded corners */
        }


        .header h1 {
            font-size: 2rem;
            color: #FFFFFF; /* Green */
            font-weight: bold;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2); /* Subtle text shadow */
            margin: 0; /* Remove default margin */
        }

        
        .admin-info .admin-actions {
            margin-top: 10px; /* Space above buttons */
        }

        .admin-action-btn {
            background-color: #00796b; /* Green */
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 15px;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.3s;
        }

        .admin-action-btn:hover {
            background-color: #004d40; /* Darker green on hover */
        }

        .content-section {
            display: none;
        }

        .content-section.active {
            display: block;
        }

        .dashboard-summary {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .summary-card {
            background-color: #e9f5e9; /* Light blue */
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 23%;
            text-align: center;
            min-width: 200px; /* Minimum width for scalability */
            transition: transform 0.3s;
        }

        .summary-card:hover {
            transform: scale(1.05); /* Scale effect on hover */
        }

        .summary-card h3 {
            color: #00796b; /* Green */
            margin: 0;
            font-size: 1.5rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            text-align: center;
            padding: 12px;
            border: 1px solid #ddd;
        }

        th {
            background-color: #e9f5e9; /* Light green */
        }

        tr:hover {
            background-color: #e9f5e9; /* Light blue */
        }

        .action-btn {
            background-color: #00796b; /* Green */
            color: white;
            border: none;
            border-radius: 6px;
            padding: 6px 12px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .action-btn:hover {
            background-color: #004d40; /* Darker green on hover */
        }

        .search-bar {
            margin-bottom: 15px;
            padding: 10px;
            width: 100%;
            border-radius: 6px;
            border: 1px solid #ddd;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar" onclick="toggleSidebar()">
        <h2 id="sidebarTitle">Admin Panel</h2>
        <a href="#" onclick="showSection('dashboard'); setActiveLink(this);" class="active">Dashboard</a>
        <a href="Analytics.html" onclick="setActiveLink(this);">Analytics</a>
        <a href="admininfo.php" onclick="setActiveLink(this);">Admin Info</a>

        <button class="logout-btn" onclick="logout()">Logout</button>
    </div>

    <div class="container" id="mainContent">
        <div id="dashboard" class="content-section active">
            <div class="header">
               
                <h1>Dashboard</h1>
               
            </div>

            <div class="dashboard-summary">
                <div class="summary-card">
                    <h3>Total Users</h3>
        <p id="totalUsers">0</p> 
                </div>
                <div class="summary-card">
    <h3>Active Users</h3>
    <p id="active-users-count">0</p>  <!-- Dynamically update hoga -->
</div>
<div class="summary-card">
    <h3>Inactive Users</h3>
    <p id="inactive-users-count">0</p>  <!-- Dynamically update hoga -->
</div>
            </div>

            <h2>User Details</h2>
            <input type="text" id="searchBar" class="search-bar" placeholder="Search by Name" onkeyup="searchUsers()">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="userTable">
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
 // ✅ Fetch total users (sabse pehle execute hoga)
$totalUsers = 0;

$totalUsersQuery = "SELECT COUNT(*) AS total FROM users";
$totalResult = $conn->query($totalUsersQuery);

if ($totalResult) {
    $row = $totalResult->fetch_assoc();
    $totalUsers = isset($row['total']) ? (int)$row['total'] : 0;
} else {
    die("Query Failed: " . $conn->error);
}




                             // Fetch user details **(FIX: status field add kar di)**
                            $sql = "SELECT id, username, email, status FROM users"; 
                            $result = $conn->query($sql);

                            if ($result->num_rows > 0) {
                            while ($row = $result->fetch_assoc()) {
                                  $status = $row['status']; // ✅ Status direct fetch ho raha hai
                                  $statusText = ($status == 'blocked') ? 'Unblock' : 'Block';
                                $buttonColor = ($status == 'blocked') ? 'red' : '#00796b';

                            echo "<tr id='row-{$row['id']}'>";
                            echo "<td>{$row['id']}</td>";
                            echo "<td>{$row['username']}</td>";
                            echo "<td>{$row['email']}</td>";
                            echo "<td>
                            <button id='status-btn-{$row['id']}' class='action-btn' style='background-color: $buttonColor;' onclick='toggleBlockUser({$row['id']})'>$statusText</button>
                         <button class='action-btn' onclick='deleteUser(\"{$row['id']}\")'>Delete</button>
                          </td>";
                         echo "</tr>";
                                       }
                                    } else {
                         echo "<tr><td colspan='4'>No users found</td></tr>";
                        }

                        $conn->close();
                    ?>


                </tbody>
            </table>
        </div>

    <script>


         document.getElementById("totalUsers").innerText = "<?php echo $totalUsers; ?>";
        // Toggle Sidebar
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('expanded');
            const sidebarTitle = document.getElementById('sidebarTitle');
            sidebarTitle.style.display = sidebar.classList.contains('expanded') ? 'block' : 'none';
        }

        // Set active link
        function setActiveLink(link) {
            const links = document.querySelectorAll('.sidebar a');
            links.forEach((link) => link.classList.remove('active'));
            link.classList.add('active');
        }

        // Show specific content section
        function showSection(sectionId) {
            const sections = document.querySelectorAll('.content-section');
            sections.forEach((section) => section.classList.remove('active'));

            const activeSection = document.getElementById(sectionId);
            activeSection.classList.add('active');
        }

        // Logout functionality
        function logout() {
            // Display a confirmation prompt
    if (confirm("Are you sure you want to log out?")) {
        // Redirect to the logout.php page to handle session destruction
        window.location.href = "logout.php";
    } else {
        alert("Logout cancelled.");
    }
        }

        // Search users
        function searchUsers() {
            const input = document.getElementById("searchBar");
            const filter = input.value.toUpperCase();
            const table = document.getElementById("userTable");
            const tr = table.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                const td = tr[i].getElementsByTagName("td")[1];
                if (td) {
                    const txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }



      
function deleteUser(userId) {
    if (confirm("Are you sure you want to delete this user?")) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "delete_user.php", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4) {
                console.log("Response: ", xhr.responseText); // Debugging output
                if (xhr.status == 200) {
                    alert(xhr.responseText);
                    if (xhr.responseText.includes("User deleted successfully")) {
                        document.getElementById("row-" + userId).remove(); // Remove row
                    }
                } else {
                    alert("Error deleting user!");
                }
            }
        };

        console.log("Sending ID: " + userId); // Debugging output
        xhr.send("id=" + userId);
    }
}
function toggleBlockUser(userId) {
    if (confirm("Are you sure you want to change this user's status?")) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "block_user.php", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                console.log("Response: " + xhr.responseText); // Debugging

                var button = document.getElementById("status-btn-" + userId);
                if (button) {
                    if (xhr.responseText.trim() === "blocked") {
                        button.innerText = "Unblock";
                        button.style.backgroundColor = "red";  
                    } else if (xhr.responseText.trim() === "active") {
                        button.innerText = "Block";
                        button.style.backgroundColor = "#00796b";  
                    }
                }
            }
        };

        xhr.send("id=" + userId);
    }
}

function updateUserCounts() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "get_user_counts.php", true);

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var data = JSON.parse(xhr.responseText);
            document.getElementById("active-users-count").innerText = data.active;
            document.getElementById("inactive-users-count").innerText = data.blocked;
        }
    };

    xhr.send();
}

// ✅ Real-time update har 5 second baad
setInterval(updateUserCounts, 5000);

// ✅ Page load hote hi call karo
updateUserCounts();

      
    </script>
</body>
</html> 