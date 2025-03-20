<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>

<%
    // Ensure user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login to view your booking history.");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking History</title>
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
            width: 80%;
            margin: auto;
            text-align: center;
            padding: 20px;
            background: white;
            box-shadow: 0px 0px 10px gray;
            border-radius: 8px;
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
        }
        .cancel-btn {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 5px;
        }
        .cancel-btn:hover {
            background: #c82333;
        }
        .success {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="header.jsp" />

    <div class="header">
        Your Booking History
    </div>

    <div class="container">
        <h2>Booking Details</h2>

        <%-- Show success/error messages --%>
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            if (message != null) { %>
                <p class="success"><%= message %></p>
        <% } else if (error != null) { %>
                <p class="error"><%= error %></p>
        <% } %>

        <table>
            <tr>
                <th>Bus Name</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Available Seats</th>
                <th>Booking Date</th>
                <th>Action</th>
            </tr>

            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();
                    String query = "SELECT b.bus_name, b.source, b.destination, b.available_seats, bk.booking_time, bk.id FROM bookings bk JOIN buses b ON bk.bus_id = b.id WHERE bk.user_id = ?";
                    ps = conn.prepareStatement(query);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();

                    boolean hasBookings = false;

                    while (rs.next()) {
                        hasBookings = true;
            %>
                        <tr>
                            <td><%= rs.getString("bus_name") %></td>
                            <td><%= rs.getString("source") %></td>
                            <td><%= rs.getString("destination") %></td>
                            <td><%= rs.getInt("available_seats") %></td>
                            <td><%= rs.getTimestamp("booking_time") %></td>
                            <td>
                                <a href="CancelBookingServlet?bookingId=<%= rs.getInt("id") %>" class="cancel-btn">Cancel</a>
                            </td>
                        </tr>
            <%
                    }
                    if (!hasBookings) {
            %>
                        <tr>
                            <td colspan="6" style="color: red;">No bookings found.</td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="6" style="color: red;">Error fetching booking history.</td>
                </tr>
            <%
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </table>
    </div>

</body>
</html>
