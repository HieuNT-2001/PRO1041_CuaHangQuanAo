package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class Xjdbc {

    public static String connectionUrl
            = "jdbc:sqlserver://localhost:1433;"
            + "database=PRO1041_CuaHangQuanAo;"
            + "user=sa;"
            + "password=123456;"
            + "encrypt=true;"
            + "trustServerCertificate=true;"
            + "loginTimeout=30;";

}
