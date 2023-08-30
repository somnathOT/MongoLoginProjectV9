<!DOCTYPE html>
<html>
<head>
    <title>Registration Page</title>
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
        
        .registration-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 400px;
            text-align: center;
        }
        
        .logo {
            margin-bottom: 2rem!important;
            font-size: 2.125rem;
            font-weight: 800;
            color: #101c2f;
            margin-bottom: 1.5rem;
        }
        
        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        
        button {
            background-color: #1877f2;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
        }

        .registration-button {
            margin-left: 10px;
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
    <div class="registration-container">
        <div class="logo"><h2>Registration</h2></div>
        <form action="RegisterServlet" method="post">
            <label for="username">User name:</label>
            <input type="text" id="username" name="username" required><br><br>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required><br><br>
            
            <button type="submit" class="registration-button">Register</button>
        </form>
    </div>
    
    <div class="toast" id="toast"></div>
    
    <script>
        const toastMessage = '<%= request.getAttribute("toastMessage") %>';

        if (toastMessage && toastMessage !== "null") {
            showToast(toastMessage);
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
