package com.busbooking.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.busbooking.dao.DBConnection;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please login to cancel a booking.");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        Connection conn = null;
        PreparedStatement psFindBooking = null, psDeleteBooking = null, psUpdateSeats = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Find the bus_id from the booking
            String findBookingQuery = "SELECT bus_id FROM bookings WHERE id=?";
            psFindBooking = conn.prepareStatement(findBookingQuery);
            psFindBooking.setInt(1, bookingId);
            rs = psFindBooking.executeQuery();

            if (rs.next()) {
                int busId = rs.getInt("bus_id");

                // Delete the booking
                String deleteBookingQuery = "DELETE FROM bookings WHERE id=?";
                psDeleteBooking = conn.prepareStatement(deleteBookingQuery);
                psDeleteBooking.setInt(1, bookingId);
                psDeleteBooking.executeUpdate();

                // Increase the available seats count
                String updateSeatsQuery = "UPDATE buses SET available_seats = available_seats + 1 WHERE id=?";
                psUpdateSeats = conn.prepareStatement(updateSeatsQuery);
                psUpdateSeats.setInt(1, busId);
                psUpdateSeats.executeUpdate();

                conn.commit(); // Commit transaction
                response.sendRedirect("booking-history.jsp?message=Booking canceled successfully.");
            } else {
                response.sendRedirect("booking-history.jsp?error=Booking not found.");
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // Rollback on error
            } catch (Exception ignored) {}
            e.printStackTrace();
            response.sendRedirect("booking-history.jsp?error=Error canceling booking.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (psFindBooking != null) psFindBooking.close();
                if (psDeleteBooking != null) psDeleteBooking.close();
                if (psUpdateSeats != null) psUpdateSeats.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
