package Conexao;

import java.sql.SQLException;

public class Update extends Conn {

    public Update(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        super(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public void transacao(int idMes, int idUs, String trans, float valor) throws SQLException {
        connect();

        String sql1 = String.format("update mes set transacoes = '%s' where id = %d and idUsuario = %d;", trans, idMes, idUs);
        String sql2 = String.format("update usuario set saldo = (saldo + (%f)) where id = %d;", valor, idUs);

        try {
            myStmt.executeUpdate(sql1);
            myStmt.executeUpdate(sql2);
        } finally {
            close();
        }
    }

    public void dados(int id, String nome, String email) throws SQLException {
        connect();

        sql = String.format("update usuario set nome = '%s', email = '%s' where id = %d;", nome, email, id);

        try {
            myStmt.executeUpdate(sql);
        } finally {
            close();
        }
    }

    public void senha(int id, String senha) throws SQLException {
        connect();

        sql = String.format("update usuario set senha = md5('%s');", senha);

        try {
            myStmt.executeUpdate(sql);
        } finally {
            close();
        }
    }
}
