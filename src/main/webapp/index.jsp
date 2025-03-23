<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bus Booking System - Home</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-image: url('https://source.unsplash.com/1600x900/?road,city'); /* Background Image */
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
        }

        /* Navbar */
        .navbar {
            background: #007bff;
            padding: 15px;
            text-align: center;
            color: white;
            font-size: 22px;
            font-weight: bold;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 50px;
        }
        .nav-links {
            display: flex;
            gap: 20px;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 8px 15px;
            border-radius: 5px;
            transition: 0.3s;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .logout-btn {
            background: #dc3545;
            padding: 8px 15px;
            border-radius: 5px;
        }
        .logout-btn:hover {
            background: #c82333;
        }

        /* Main Content */
        .container {
            background: rgba(255, 255, 255, 0.95); /* Semi-transparent box */
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 450px;
            margin: 100px auto;
        }

        /* Welcome Text */
        .welcome-text {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        /* Subtitle */
        .subtitle {
            font-size: 16px;
            color: #555;
            margin-bottom: 20px;
        }

        /* Buttons */
        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            font-size: 18px;
            text-align: center;
            text-decoration: none;
            color: white;
            border-radius: 5px;
            margin-top: 15px;
            transition: 0.3s;
            font-weight: bold;
            border: none;
        }
        .btn-primary {
            background: #007bff;
        }
        .btn-primary:hover {
            background: #0056b3;
        }
        .btn-danger {
            background: #dc3545;
        }
        .btn-danger:hover {
            background: #c82333;
        }
        
        /* Icons */
        .icon {
            font-size: 50px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <span>🚍 Bus Booking System</span>
        <div class="nav-links">
            <a href="index.jsp">🏠 Home</a>
            <a href="bus-list.jsp">🚆 View Buses</a>
            <a href="booking-history.jsp">📜 Booking History</a>
            <a href="LogoutServlet" class="logout-btn">🚪 Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="icon">🚌</div>
        <div class="welcome-text">Welcome to the Bus Booking System</div>
        <div class="subtitle">Book your bus tickets easily and travel hassle-free!</div>

        <%
            // Check if the user is logged in
            String user = (String) session.getAttribute("userName");
            if (user == null) {
        %>
            <!-- If user is NOT logged in -->
            <a href="login.jsp" class="btn btn-primary">🔑 Login</a>
            <a href="register.jsp" class="btn btn-primary">📝 Register</a>
        <%
            } else {
        %>
            <!-- If user IS logged in -->
            <a href="bus-list.jsp" class="btn btn-primary">🚆 View Available Buses</a>
            <a href="LogoutServlet" class="btn btn-danger">🚪 Logout</a>
        <%
            }
        %>
    </div>

</body>
</html>
