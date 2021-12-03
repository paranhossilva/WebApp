package Modelos;

import java.util.ArrayList;

public class Transacao {
    private final ArrayList<Integer> desc = new ArrayList();
    private final ArrayList<Float> valor = new ArrayList();
    private float total = 0;

    public ArrayList<Integer> getDesc() {
        return desc;
    }

    public ArrayList<Float> getValor() {
        return valor;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total += total;
    }
}