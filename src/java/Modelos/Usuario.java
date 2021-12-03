package Modelos;

public class Usuario {
    private String nome, email;
    private int id;

    public String getNome() {
        return nome;
    }

    public String getEmail() {
        return email;
    }

    public int getId() {
        return id;
    }

    public Usuario(String usuario, String email, int id) {
        this.nome = usuario;
        this.email = email;
        this.id = id;
    } 
}
