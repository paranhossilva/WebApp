package Conexao;

import java.sql.SQLException;

public class Verifica extends Conn {

    public Verifica(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        super(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public boolean login(String usuario) throws SQLException {
        connect();
        
        boolean ret = true;

        sql = String.format("select login from usuario where login = '%s';", usuario);

        try {
            myRs = myStmt.executeQuery(sql);     
            
            ret = myRs.next();
        } finally {            
            close();
        }
        
        return ret;
    }

    public boolean mes(int mes, int ano, int id) throws SQLException {
        connect();
        
        boolean ret = true;

        sql = String.format("select id from mes where mes = %d and ano = %d and idUsuario = %d;", mes, ano, id);

        try {
            myRs = myStmt.executeQuery(sql);     
            
            ret = myRs.next();
        } finally {            
            close();
        }
        
        return ret;
    }

    public int tutor(String usuario) throws SQLException {
        connect();

        int idTutor = -1;

        sql = String.format("select id from usuario where login = '%s';", usuario);

        try {
            myRs = myStmt.executeQuery(sql);

            if (myRs.next()) {
                idTutor = myRs.getInt(1);
            }

        } finally {
            close();           
        }
        
        return idTutor;
    }

    public boolean tutoria(int idUs, int idTutor) throws SQLException {
        connect();

        sql = String.format("select id from tutoria where idUsuario = %d and idTutor = %d;", idUs, idTutor);

        boolean ret = true;

        try {
            myRs = myStmt.executeQuery(sql);

            ret = !myRs.next();
        } finally {
            close();
        }

        return ret;
    }

    public boolean tutorado(int id) throws SQLException {
        connect();

        sql = String.format("select id from tutoria where idUsuario = %d;", id);

        boolean ret = false;

        try {
            myRs = myStmt.executeQuery(sql);

            ret = myRs.next();
        } finally {
            close();
        }

        return ret;
    }

    public boolean tutora(int id) throws SQLException {
        connect();

        sql = String.format("select id from tutoria where idTutor = %d;", id);

        boolean ret = false;

        try {
            myRs = myStmt.executeQuery(sql);

            ret = myRs.next();
        } finally {
            close();
        }

        return ret;
    }

    public boolean tutorUsuario(int idUs, int idTutor) throws SQLException {
        connect();

        sql = String.format("select id from tutoria where idUsuario = %d and idTutor = %d;", idUs, idTutor);

        boolean ret = false;

        try {
            myRs = myStmt.executeQuery(sql);

            ret = myRs.next();
        } finally {
            close();
        }           
        
        return ret;
    }
}
