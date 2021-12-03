package Conexao;

import java.sql.SQLException;

public class Insert extends Conn {

    public Insert(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        super(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public void usuario(String nome, String usuario, String email, String senha) throws SQLException {
        connect();

        sql = String.format("insert into usuario(nome, login, senha, email, saldo) values ('%s, '%s', md5('%s'), '%s', 0 );", nome, usuario, senha, email);

        try {
            myStmt.executeUpdate(sql);
        }
        finally {
            close();
        }
    }

    public void mes(int mes, int ano, int id) throws SQLException {
        connect();

        String trans = "{\"desc\":[],\"valor\":[],\"total\":0}";

        sql = String.format("insert into mes(mes, ano, transacoes, idUsuario) values (%d, %d, '%s',  %d);", mes, ano, trans, id);

        try {
            myStmt.executeUpdate(sql);
        } 
        finally {
            close();
        }
    }
    
    public void tutor(int idUs, int idTutor) throws SQLException {
        connect();

        sql = String.format("insert into tutoria(idusuario, idTutor) values (%d, %s);", idUs, idTutor);

        try {
            myStmt.executeUpdate(sql);
        } 
        finally {
            close();
        }
    }
}
