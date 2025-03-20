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

@WebServlet("/EditBusServlet")
public class EditBusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int busId = Integer.parseInt(request.getParameter("busId"));
        String busName = request.getParameter("busName");
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        int seats = Integer.parseInt(request.getParameter("seats"));
        String departureTime = request.getParameter("departureTime");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE buses SET bus_name=?, source=?, destination=?, available_seats=?, departure_time=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, busName);
            ps.setString(2, source);
            ps.setString(3, destination);
            ps.setInt(4, seats);
            ps.setString(5, departureTime);
            ps.setInt(6, busId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("manage-buses.jsp?message=Bus updated successfully.");
            } else {
                response.sendRedirect("edit-bus.jsp?error=Failed to update bus.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit-bus.jsp?error=Error occurred.");
        } finally {
            try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
