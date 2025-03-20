<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirm Booking</title>
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
        .btn {
            padding: 10px 20px;
            font-size: 18px;
            text-decoration: none;
            color: white;
            background: #28a745;
            border-radius: 5px;
        }
        .btn:hover {
            background: #218838;
        }
    </style>
</head>
<body>

    <!-- Include Header -->
    <jsp:include page="header.jsp" />

    <div class="header">
        Confirm Booking
    </div>

    <div class="container">
        <h2>Bus Details</h2>

        <%
            int busId = Integer.parseInt(request.getParameter("busId"));
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            String busName = "", source = "", destination = "";
            int availableSeats = 0;
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
                    availableSeats = rs.getInt("available_seats");
                    departureTime = rs.getTimestamp("departure_time").toString();
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>

        <p><b>Bus Name:</b> <%= busName %></p>
        <p><b>From:</b> <%= source %> → <b>To:</b> <%= destination %></p>
        <p><b>Seats Available:</b> <%= availableSeats %></p>
        <p><b>Departure Time:</b> <%= departureTime %></p>

        <form action="BookBusServlet" method="post">
            <input type="hidden" name="busId" value="<%= busId %>">
            <input type="submit" class="btn" value="Confirm Booking">
        </form>
    </div>

</body>
</html>
