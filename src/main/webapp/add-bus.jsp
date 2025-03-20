<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Bus</title>
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
            width: 50%;
            margin: auto;
            text-align: center;
            padding: 20px;
            background: white;
            box-shadow: 0px 0px 10px gray;
            border-radius: 8px;
            margin-top: 50px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            width: 100%;
            padding: 10px;
            background: #28a745;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }
        .btn:hover {
            background: #218838;
        }
        .error, .success {
            text-align: center;
            font-size: 16px;
            font-weight: bold;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
    </style>
</head>
<body>

    <!-- Include Header -->
    <jsp:include page="header.jsp" />

    <div class="header">
        Add a New Bus
    </div>

    <div class="container">
        <h2>Bus Details</h2>

        <%-- Display success or error messages --%>
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            if (message != null) { %>
                <p class="success"><%= message %></p>
        <% } else if (error != null) { %>
                <p class="error"><%= error %></p>
        <% } %>

        <form action="AddBusServlet" method="post">
            <label>Bus Name:</label>
            <input type="text" name="busName" placeholder="Enter Bus Name" required>

            <label>Source:</label>
            <input type="text" name="source" placeholder="Enter Source City" required>

            <label>Destination:</label>
            <input type="text" name="destination" placeholder="Enter Destination City" required>

            <label>Seats Available:</label>
            <input type="number" name="seats" placeholder="Enter Available Seats" required min="1">

            <label>Departure Time:</label>
            <input type="datetime-local" name="departureTime" required>

            <input type="submit" class="btn" value="Add Bus">
        </form>
    </div>

</body>
</html>
