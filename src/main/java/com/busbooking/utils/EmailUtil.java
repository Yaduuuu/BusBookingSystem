package com.busbooking.utils;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {
    public static void sendEmail(String toEmail, String subject, String messageBody) {
        final String fromEmail = "travelplanner04@gmail.com"; // Your Gmail
        final String password = "clge xumy uqje gmrb";         // App password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            System.out.println("📤 Preparing to send email to: " + toEmail);
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(messageBody);

            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + toEmail);
        } catch (MessagingException e) {
            System.out.println("❌ Email sending failed to: " + toEmail);
            e.printStackTrace();
        }
    }
}
