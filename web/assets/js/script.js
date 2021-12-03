const descricoes = ["Alimentação", "Assinaturas e Serviços", "Bares e Restaurantes", "Casa", "Compras", "Cuidados Pessoais", "Dívidas e Empréstimos", "Educação", "Família e Filhos",
/* Despesas -> */ "Impostos e Taxas", "Investimentos", "Lazer e Hobbies", "Mercado", "Pets", "Presentes e Doações", "Roupas", "Saúde", "Trabalho", "Transporte", "Viagens", "Outros",
/* Receitas -> */ "Salário", "Empréstimos", "Investimentos", "Outras Receitas"];

function excluirMes() {
    var conf = confirm("Deseja excluir o mês selecionado?");
    if (conf) {
        document.getElementById("excluirmes").submit();
    }
}

function excluirTrans(index, idMes) {
    var conf = confirm("Deseja excluir a transação?");
    if (conf) {
        location.href = ("Excluir?index=" + index + "&idmes=" + idMes + "&pagina=deltrans");
    }
}

function mudaDesc(tipo){
    var desc = document.getElementById("desc_id");
    
    desc.disabled = false;
    
    
    
    while (desc.length) {
        desc.remove(0);
    }
    switch(tipo){
        case "despesa":
            for (var i = 0; i < 21; i++) {
                var opcao = document.createElement('option');
                opcao.value = i;
                opcao.innerHTML = descricoes[i];
                desc.appendChild(opcao);
            }
            
            break;
        case "receita":
            for (var i = 21; i < 25; i++) {
                var opcao = document.createElement('option');
                opcao.value = i;
                opcao.innerHTML = descricoes[i];
                desc.appendChild(opcao);
            }
            
            break;
    }
}

function limpaDesc(){
    var desc = document.getElementById("desc_id");   
    
    desc.disabled = true; 
    
    while (desc.length) {
        desc.remove(0);
    }
}