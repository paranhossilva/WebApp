package Modelos;

public class Descricoes {
    private final String[] descricoes = {"Alimentação", "Assinaturas e Serviços", "Bares e Restaurantes", "Casa", "Compras", "Cuidados Pessoais", "Dívidas e Empréstimos", "Educação", "Família e Filhos",
    /* Despesas -> */            "Impostos e Taxas", "Investimentos", "Lazer e Hobbies", "Mercado", "Pets", "Presentes e Doações", "Roupas", "Saúde", "Trabalho", "Transporte", "Viagens", "Outros",
    /* Receitas -> */            "Salário", "Empréstimos", "Investimentos", "Outras Receitas"};
    
    public String get(int i){
        return descricoes[i];
    }
}