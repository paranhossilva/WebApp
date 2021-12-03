package Conexao;

import java.sql.SQLException;

public class Delete extends Conn {

    public Delete(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        super(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public void mes(int id, int idUs, float total) throws SQLException {
        connect();

        String sql1 = String.format("delete from mes where id = %d and idUsuario = %d;", id, idUs);
        String sql2 = String.format("update usuario set saldo = (saldo - (%s)) where id = %f;", total, idUs);

        try {
            myStmt.executeUpdate(sql1);
            myStmt.executeUpdate(sql2);
        } finally {
            close();
        }
    }

    public void tutor(int idUs, int idTutor) throws SQLException {
        connect();

        sql = String.format("delete from tutoria where idusuario = %d and idTutor = %d;", idUs, idTutor);

        try {
            myStmt.executeUpdate(sql);
        } finally {
            close();
        }
    }
}
