<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings</title>
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
            width: 90%;
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
            background: white;
        }
        th, td {
            padding: 12px;
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
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }
        .cancel-btn:hover {
            background: #c82333;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <div class="header">
        Manage Bookings
    </div>
<jsp:include page="header.jsp" />
    <div class="container">
        <h2>List of Bookings</h2>

        <table>
            <tr>
                <th>User ID</th>
                <th>Bus Name</th>
                <th>Seat Number</th>
                <th>Booking Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT bk.id, bk.user_id, b.bus_name, bk.seat_number, bk.booking_date, bk.status FROM bookings bk JOIN buses b ON bk.bus_id = b.id");
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getInt("user_id") %></td>
                            <td><%= rs.getString("bus_name") %></td>
                            <td><%= rs.getInt("seat_number") %></td>
                            <td><%= rs.getTimestamp("booking_date") %></td>
                            <td><%= rs.getString("status") %></td>
                            <td>
                                <% if (rs.getString("status").equals("CONFIRMED")) { %>
                                    <a href="CancelBookingServlet?bookingId=<%= rs.getInt("id") %>" class="cancel-btn">Cancel</a>
                                <% } else { %>
                                    <span style="color: gray;">Canceled</span>
                                <% } %>
                            </td>
                        </tr>
            <%
                    }
                }
            %>
        </table>
    </div>

</body>
</html>
