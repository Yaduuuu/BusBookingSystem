<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Bus</title>
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
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            width: 100%;
            padding: 10px;
            background: #ffc107;
            color: black;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }
        .btn:hover {
            background: #e0a800;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .success {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <!-- Include Header for Navigation -->
    <jsp:include page="header.jsp" />

    <div class="header">
        Edit Bus Details
    </div>

    <div class="container">
        <h2>Update Bus Information</h2>

        <%-- Show error or success messages --%>
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            if (message != null) { %>
                <p class="success"><%= message %></p>
        <% } else if (error != null) { %>
                <p class="error"><%= error %></p>
        <% } %>

        <%
            int busId = Integer.parseInt(request.getParameter("busId"));
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String busName = "", source = "", destination = "";
            int seats = 0, availableSeats = 0;
            String departureTime = "";

            try {
                conn = DBConnection.getConnection();
                ps = conn.prepareStatement("SELECT * FROM buses WHERE id=?");
                ps.setInt(1, busId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    busName = rs.getString("bus_name");
                    source = rs.getString("source");
                    destination = rs.getString("destination");
                    seats = rs.getInt("available_seats");
                    availableSeats = rs.getInt("available_seats");
                    
                    // Convert timestamp to proper datetime-local format
                    Timestamp depTime = rs.getTimestamp("departure_time");
                    if (depTime != null) {
                        departureTime = depTime.toString().replace(" ", "T");
                    }
                } else {
                    response.sendRedirect("manage-buses.jsp?error=Bus not found.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("manage-buses.jsp?error=Database error.");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>

        <form action="EditBusServlet" method="post">
            <input type="hidden" name="busId" value="<%= busId %>">

            <label>Bus Name:</label>
            <input type="text" name="busName" value="<%= busName %>" required>

            <label>Source:</label>
            <input type="text" name="source" value="<%= source %>" required>

            <label>Destination:</label>
            <input type="text" name="destination" value="<%= destination %>" required>

            <label>Total Seats:</label>
            <input type="number" name="seats" value="<%= seats %>" required min="1">

            <label>Available Seats:</label>
            <input type="number" name="availableSeats" value="<%= availableSeats %>" required min="0">

            <label>Departure Time:</label>
            <input type="datetime-local" name="departureTime" value="<%= departureTime %>" required>

            <input type="submit" class="btn" value="Update Bus">
        </form>
    </div>

</body>
</html>
