# Epidemiological Data Pipeline

Este repositório contém scripts e ferramentas para **coleta, processamento e análise de dados epidemiológicos** no Brasil, com foco inicial em **Zika**, **Chikungunya** e **Dengue**. O objetivo é estabelecer um pipeline automatizado que permita a **atualização periódica dos dados**, **limpeza e padronização** das tabelas, e posterior **construção de dashboards interativos** em diversas plataformas (Django em Python, Shiny em R, Power BI e outras plataformas).

---

## 🧩 Estrutura do Projeto

```
.
├── scripts/
│   ├── download_dengue.sh
│   ├── download_zika.sh
│   ├── download_chikungunya.sh
│   └── processar_dados.sh
├── data/
│   ├── brutos/
│   ├── processados/
│   └── logs/
├── dashboards/
│   ├── dash/
│   ├── shiny/
│   └── powerbi/
└── README.md
```

---

## ⚙️ Automação de Download

Os scripts de download utilizam `wget` e `curl` para verificar e baixar arquivos da base pública de **arboviroses do DataSUS**.  
A automação pode ser agendada com **cron** no Linux

O script verifica:
- Se o arquivo foi atualizado desde o último download.
- Se não houver mudanças, registra no log: `Nenhuma modificação detectada`.
- Se houver nova versão, baixa o arquivo e extrai os CSV automaticamente.

---

## 🧹 Processamento dos Dados

Após o download, os arquivos são descompactados e processados com `gawk` e `duckdb` para:
- Padronizar colunas e formatos de data.
- Corrigir erros estruturais em CSVs.
- Unificar diferentes períodos em um único arquivo otimizado (`.duckdb`).

---

## 📊 Dashboards

Os dados processados serão utilizados em dashboards em diferentes ambientes:

- **Django (Python)**
- **Shiny (R)**
- **Power BI**

Cada dashboard será alimentado diretamente pelos dados locais processados.

---

## 🧠 Tecnologias Utilizadas

| Categoria | Ferramenta |
|------------|-------------|
| Download e automação | `bash`, `wget`, `curl`, `cron` |
| Processamento | `gawk`, `duckdb`, `awk`, `sqlite` |
| Visualização | `dash`, `plotly`, `shiny`, `powerbi` |
| Controle de versão | `git`, `github` |

---

## 🚀 Próximos Passos

- [x] Scripts automáticos de download e log.
- [ ] Integração com `DuckDB` para pré-processamento.
- [ ] Construção dos dashboards com dados reais.
- [ ] Criação de documentação dos datasets.

---

## 🧑‍💻 Autor

**Candido Sobrinho**  
📧 [Contato profissional](mailto:contato@exemplo.com)  
🌐 [LinkedIn](https://linkedin.com/in/exemplo)  
📍 Brasil

---

> Projeto em desenvolvimento — contribuições e sugestões são bem-vindas!
