package com.busbooking.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.busbooking.dao.DBConnection;

@WebServlet("/DeleteBusServlet")
public class DeleteBusServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int busId = Integer.parseInt(request.getParameter("busId"));
        Connection conn = null;
        PreparedStatement psDeleteBookings = null, psDeleteBus = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Delete all bookings related to this bus
            String deleteBookingsQuery = "DELETE FROM bookings WHERE bus_id=?";
            psDeleteBookings = conn.prepareStatement(deleteBookingsQuery);
            psDeleteBookings.setInt(1, busId);
            psDeleteBookings.executeUpdate();

            // Now delete the bus
            String deleteBusQuery = "DELETE FROM buses WHERE id=?";
            psDeleteBus = conn.prepareStatement(deleteBusQuery);
            psDeleteBus.setInt(1, busId);
            psDeleteBus.executeUpdate();

            conn.commit(); // Commit transaction
            response.sendRedirect("manage-buses.jsp?message=Bus deleted successfully.");
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            e.printStackTrace();
            response.sendRedirect("manage-buses.jsp?error=Error deleting bus.");
        } finally {
            try {
                if (psDeleteBookings != null) psDeleteBookings.close();
                if (psDeleteBus != null) psDeleteBus.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
