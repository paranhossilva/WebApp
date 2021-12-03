package Modelos;


public class Mes {
    private final int id, mes, ano;

    public int getId() {
        return id;
    }

    public int getMes() {
        return mes;
    }

    public int getAno() {
        return ano;
    }

    public Mes(int id, int mes, int ano) {
        this.id = id;
        this.mes = mes;
        this.ano = ano;
    }
}
