package com.busbooking.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.busbooking.dao.DBConnection;
import com.busbooking.utils.EmailUtil;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please login to cancel bookings.");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int userId = (int) session.getAttribute("userId");
        String userEmail = (String) session.getAttribute("userEmail");

        Connection conn = null;
        PreparedStatement ps = null, psUpdateSeats = null, psFetchDetails = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Fetch bus_id for restoring the seat and booking info for email
            psFetchDetails = conn.prepareStatement(
                "SELECT b.bus_name, b.source, b.destination, b.departure_time, bk.bus_id " +
                "FROM bookings bk JOIN buses b ON bk.bus_id = b.id " +
                "WHERE bk.id = ? AND bk.user_id = ? AND bk.status = 'CONFIRMED'"
            );
            psFetchDetails.setInt(1, bookingId);
            psFetchDetails.setInt(2, userId);
            rs = psFetchDetails.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("booking-history.jsp?error=Invalid booking or already canceled.");
                return;
            }

            int busId = rs.getInt("bus_id");
            String busName = rs.getString("bus_name");
            String source = rs.getString("source");
            String destination = rs.getString("destination");
            Timestamp departureTime = rs.getTimestamp("departure_time");

            // Mark the booking as canceled
            ps = conn.prepareStatement("UPDATE bookings SET status='CANCELED' WHERE id=? AND user_id=?");
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ps.executeUpdate();

            // Restore 1 seat
            psUpdateSeats = conn.prepareStatement("UPDATE buses SET available_seats = available_seats + 1 WHERE id=?");
            psUpdateSeats.setInt(1, busId);
            psUpdateSeats.executeUpdate();

            conn.commit();

            // 📧 Send cancellation email
            String subject = "Bus Ticket Booking Cancellation";
            String message = "Dear User,\n\nYour bus ticket has been canceled successfully.\n\n" +
                    "Bus: " + busName + "\n" +
                    "From: " + source + "\n" +
                    "To: " + destination + "\n" +
                    "Departure: " + departureTime + "\n\n" +
                    "If this was not you, please contact support.";

            System.out.println("📤 Sending cancellation email to: " + userEmail);
            EmailUtil.sendEmail(userEmail, subject, message);

            response.sendRedirect("booking-history.jsp?message=Booking canceled and email sent.");

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            e.printStackTrace();
            response.sendRedirect("booking-history.jsp?error=Error cancelling booking.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (psUpdateSeats != null) psUpdateSeats.close();
                if (psFetchDetails != null) psFetchDetails.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
