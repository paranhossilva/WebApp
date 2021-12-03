package Conexao;

import Modelos.Mes;
import Modelos.Usuario;
import java.sql.SQLException;
import java.util.ArrayList;

public class Select extends Conn {

    public Select(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        super(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public Usuario usuario(String login, String senha) throws SQLException {
        connect();
        
        Usuario usuario = null;

        sql = String.format("select id, nome, email from usuario where login = '%s' and senha = md5('%s');", login, senha);

        try {
            myRs = myStmt.executeQuery(sql);
            
            if(myRs.next())
                usuario = new Usuario(myRs.getString(2), myRs.getString(3), myRs.getInt(1));
        }
        finally {
            close();
        }           
        
        return usuario;
    }

    public ArrayList<Mes> meses(int id) throws SQLException {
        connect();
        
        ArrayList<Mes> meses = new ArrayList<>();

        sql = String.format("select id, mes, ano from mes where idUsuario = %d order by ano, mes;", id);

        try {
            myRs = myStmt.executeQuery(sql);
            
            while(myRs.next()){ 
                meses.add(new Mes(myRs.getInt(1), myRs.getInt(2), myRs.getInt(3)));
            }
        } 
        finally {
            close();
        }
            
        return meses;
    }

    public String transacao(int id) throws SQLException {
        connect();
        
        String trans = null;

        sql = String.format("select transacoes from mes where id = %d;", id);

        try {
            myRs = myStmt.executeQuery(sql);
            
            myRs.next();
            
            trans = myRs.getString(1);
        } 
        finally {
            close();
        }
            
        return trans;
    }

    public float saldo(int id) throws SQLException {
        float ret = 0;
        connect();

        sql = String.format("select saldo from usuario where id = %d;", id);

        try {
            myRs = myStmt.executeQuery(sql);

            myRs.next();

            ret = myRs.getFloat(1);

        } 
        finally {
            close();

        }
        
        return ret;
    }

    public ArrayList<Usuario> tutor(int id) throws SQLException {
        connect();
        
        ArrayList<Usuario> tutores = new ArrayList<>();

        sql = String.format("select usuario.id, usuario.nome from usuario "
                + "inner join tutoria on usuario.id = tutoria.idTutor "
                + "where tutoria.idUsuario = %d;", id);
        try {
            myRs = myStmt.executeQuery(sql);
            
            while(myRs.next()){
                tutores.add(new Usuario(myRs.getString(2), "", myRs.getInt(1)));
            }
            
        }
        finally {
            close();
        }
        
        return tutores;
    }
    
    public ArrayList<Usuario> tutorados(int id) throws SQLException {
        connect();
        
        ArrayList<Usuario> tutorados = new ArrayList<>();

        sql = String.format("select usuario.id, usuario.nome from usuario "
                   + "inner join tutoria on usuario.id = tutoria.idUsuario "
                   + "where tutoria.idTutor = %d;", id);
        
        try {
            myRs = myStmt.executeQuery(sql);
            
            while(myRs.next()){
                tutorados.add(new Usuario(myRs.getString(2), "", myRs.getInt(1)));
            }
            
        }
        finally {
            close();
        }
        
        return tutorados;
    }
    
    public String nomeTutorado(int id) throws SQLException{
        connect();
        
        String ret = "";
        
        sql = String.format("select nome from usuario where id = %d;", id);
        
        try {
            myRs = myStmt.executeQuery(sql);
            
            myRs.next();
            
            ret = myRs.getString(1);
        }finally {
            close();
        }
        
        return ret;
    }
    
    public int[] mesAno(int idMes) throws SQLException{
        connect();
        
        int[] ret = new int[2];
        
        sql = String.format("select mes, ano from mes where id = %d;", idMes);
        
        try {
            myRs = myStmt.executeQuery(sql);
            
            myRs.next();
            
            ret[0] = myRs.getInt(1);
            ret[1] = myRs.getInt(2);
        }finally {
            close();
        }
        
        return ret;
    }
}
