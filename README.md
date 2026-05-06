# Feed Aggregator API 

<img width="1470" height="956" alt="Screenshot 2026-05-06 at 14 41 53" src="https://github.com/user-attachments/assets/c9a2ab15-d214-4f9f-b702-3467aafe6fd8" />

<img width="1470" height="956" alt="Screenshot 2026-05-06 at 14 42 49" src="https://github.com/user-attachments/assets/d70e349d-5de8-4e6d-95d5-76b936bbbb4f" />


Este é um sistema para agregar itens de feeds RSS e expô-los via uma API JSON.

Visão geral

- Objetivo: cadastrar fontes (feeds), coletar periodicamente novos itens e fornecer endpoints para consumir esses itens.
- Escopo: implementação mínima viável para coleta, armazenamento e consulta de entradas de feeds.

Tecnologias 

- Ruby 3.3.1
- Rails Rails 8.1.3
- Banco de dados: PostgreSQL 

Pré-requisitos

- Ruby e Bundler instalados
- Banco de dados (Postgres ou sqlite para dev)
- Redis (opcional, para background jobs)

Instalação rápida

1. Clone o repositório

   git clone [httpsfeed+agregator-api](https://github.com/gustavo-lola/feed_aggregator_api)
   cd feed-aggregator-api

2. Instale dependências Ruby
   bundle install


Banco de dados

- Criar e migrar (Rails):
  rails db:create
  rails db:migrate
  rails db:seed   

Executando localmente
- Para executar(Rails):
  rails s

Endpoints 

- GET /api/v1/feeds — listar feeds
- POST /api/v1/feeds — cadastrar feed 
- GET /api/v1/feeds/:id/entries — listar entradas de um feed
- GET /api/v1/entries/:id — obter detalhe de uma entrada
