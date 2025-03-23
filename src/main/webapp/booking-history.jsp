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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking History</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-image: url('https://source.unsplash.com/1600x900/?travel,road'); /* Background Image */
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

        /* Main Container */
        .container {
            width: 90%;
            margin: auto;
            text-align: center;
            padding: 30px;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            margin-top: 40px;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
            font-size: 18px;
        }
        tr:nth-child(even) {
            background: #f8f9fa;
        }
        tr:hover {
            background: #e9ecef;
        }

        /* Cancel Button */
        .cancel-btn {
            background: #dc3545;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
            border: none;
            cursor: pointer;
        }
        .cancel-btn:hover {
            background: #c82333;
            transform: scale(1.05);
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
        <h2>📜 Your Booking History</h2>

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
                boolean hasBookings = false;

                try {
                    conn = DBConnection.getConnection();
                    String query = "SELECT b.bus_name, b.source, b.destination, b.available_seats, bk.booking_time, bk.id " +
                                   "FROM bookings bk JOIN buses b ON bk.bus_id = b.id " +
                                   "WHERE bk.user_id = ? AND bk.status != 'CANCELED'"; // ✅ Only show active bookings
                    ps = conn.prepareStatement(query);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();

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
                                <a href="CancelBookingServlet?bookingId=<%= rs.getInt("id") %>" class="cancel-btn">❌ Cancel</a>
                            </td>
                        </tr>
            <%
                    }
                    if (!hasBookings) {
            %>
                        <tr>
                            <td colspan="6" style="color: red; font-weight: bold;">❌ No active bookings found.</td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="6" style="color: red; font-weight: bold;">❌ Error fetching booking history.</td>
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
