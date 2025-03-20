<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bus Booking System - Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .header {
            background: #007bff;
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
        }
        .container {
            text-align: center;
            padding: 50px;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            font-size: 18px;
            margin: 10px;
            text-decoration: none;
            color: white;
            background: #007bff;
            border-radius: 5px;
        }
        .btn:hover {
            background: #0056b3;
        }
        .logout-btn {
            background: #dc3545;
        }
        .logout-btn:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
    <!-- Header Section -->
    <div class="header">
        Bus Booking System
    </div>

    <!-- Main Content Section -->
    <div class="container">
        <h1>Welcome to the Bus Booking System</h1>
        <p>Book your bus tickets easily and travel hassle-free!</p>

        <%
            // Check if the user is logged in
            String user = (String) session.getAttribute("userName");
            if (user == null) {
        %>
            <!-- Show these buttons if the user is NOT logged in -->
            <a href="login.jsp" class="btn">Login</a>
            <a href="register.jsp" class="btn">Register</a>
        <%
            } else {
        %>
            <!-- Show these buttons if the user IS logged in -->
            <a href="bus-list.jsp" class="btn">View Available Buses</a>
            <a href="LogoutServlet" class="btn logout-btn">Logout</a>
        <%
            }
        %>
    </div>

</body>
</html>
