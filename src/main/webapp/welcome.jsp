<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .dashboard-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 400px; /* Adjust the width as needed */
            text-align: center;
        }
        
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 8px; /* Keep a rounded border */
            background-color: #ccc; /* Placeholder color */
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            color: #fff;
            margin: 0 auto 20px; /* Center-align the profile picture */
        }
        
        .profile-picture img {
            width: 100%;
            height: 100%;
            border-radius: 8px;
            object-fit: cover;
        }

        .profile-picture img[alt="Profile Picture"] {
            font-size: 16px; /* Adjust the font size as needed */
            line-height: 150px; /* Match the line-height to the container height */
        }
        
        .user-details {
            margin-bottom: 20px;
        }
        
        .blog-input {
            width: 90%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            resize: none;
        }
        
        .logout-button {
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
        }
        
        /* Toast Styles */
        .toast {
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #333;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .toast.show {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h1>Welcome to Your Dashboard</h1>
        
        <div class="profile-picture">
            <img src="User-Profile.png" alt="Profile Picture">
        </div>
        
        <div class="user-details">
            <p><strong>Username:</strong> <%= request.getAttribute("userInfo") %></p>
        </div>
        
        <textarea class="blog-input" placeholder="Write your blog..."></textarea>
        
        <a href="login.jsp" class="logout-button">Logout</a>
    </div>
    
    <!-- Toast container -->
    <div class="toast" id="toast"></div>
    
    <script>
        // Check if the URL has a success parameter
        const success = '<%= request.getAttribute("success") %>';

        if (success === "true") {
            showToast("New user created successfully.");
        }
        
        function showToast(message) {
            const toast = document.getElementById("toast");
            toast.innerHTML = message;
            toast.classList.add("show");
            setTimeout(function() {
                toast.classList.remove("show");
            }, 3000); // Display toast for 3 seconds
        }
        
    </script>
</body>
</html>
