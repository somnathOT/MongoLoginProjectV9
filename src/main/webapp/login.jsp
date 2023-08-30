<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
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
        
        .login-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 400px; /* Adjust the width as needed */
            text-align: center;
        }
        
		.logo {
            font-size: 36px;
            color: #1877f2;
            margin-bottom: 20px;
        }
        
        .logo img {
            max-width: 100%; 
            max-height: 100px; 
        }
        
        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        
        .login-button {
            background-color: #1877f2;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px
        }
        .reg-button {
            background-color: #1877f2;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            cursor: pointer;
           	margin-left: 40px;
        }
        .toast {
            visibility: hidden;
            max-width: 300px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 4px;
            padding: 16px;
            position: fixed;
            z-index: 1;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 14px;
        }
        .show {
            visibility: visible;
            animation: fadein 0.5s, fadeout 0.5s 2.5s;
        }
        @keyframes fadein {
            from {bottom: 0; opacity: 0;}
            to {bottom: 30px; opacity: 1;}
        }
        @keyframes fadeout {
            from {bottom: 30px; opacity: 1;}
            to {bottom: 0; opacity: 0;}
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo"><img src="Open_Text_Logo.png" alt="OpenText Login"></div>
        <form action="LoginServlet" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit" class="login-button">Login</button> 
            <button type="button" class="reg-button" onclick="redirectToRegistration()">Register</button>  
            <script>
				function redirectToRegistration() 
				{
    				window.location.href = "registration.jsp";
				}
			</script> 
        </form>
    </div>
    <div class="toast" id="toast"></div>
    
    <script>
        function showToast(message) {
            const toast = document.getElementById("toast");
            toast.innerHTML = message;
            toast.classList.add("show");
            setTimeout(function() {
                toast.classList.remove("show");
            }, 3000); // Display toast for 3 seconds
        }
        
        // Check if the URL has an error parameter
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get("error");
        
        if (error) {
            showToast(decodeURIComponent(error));
        }
        
        // Check if the remainingAttempts attribute exists
        const remainingAttempts = '<%= request.getAttribute("remainingAttempts") %>';
        
        if (remainingAttempts !== 'null') {
            showToast(`Invalid password. ${remainingAttempts} attempts remaining.`);
        }
    </script>
</body>
</html>
