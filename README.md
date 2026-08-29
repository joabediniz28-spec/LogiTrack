# 🚚 LogiTrack SaaS — Infraestrutura Cloud Serverless

A **LogiTrack** é uma startup fictícia de tecnologia logística B2B operando no modelo SaaS. Este repositório contém a arquitetura completa da empresa provisionada na AWS utilizando práticas reais de mercado, foco em custo zero (Free Tier) e automação via Infraestrutura como Código (IaC).

## 🎯 O Modelo de Negócio
Oferecemos uma API de alta velocidade para cálculo de frete e roteirização inteligente para e-commerces.
* **Problema:** Lentidão no cálculo de frete que gera abandono de carrinho em pequenas plataformas de e-commerce.
* **Solução:** Uma API Serverless descentralizada que processa requisições de rotas em menos de 100ms.

## 🧭 Diretrizes de Engenharia (Cultura)
Como uma startup enxuta (máximo de 4 funcionários por setor), nossa infraestrutura foi desenhada sob três pilares:
* **Frugalidade (Eficiência de Custo):** Arquitetura 100% Serverless para garantir cobrança estritamente baseada no uso (Pay-as-you-go), mantendo o custo operacional em $0 durante a validação.
* **Segurança Baseada em Identidade (Zero Trust):** Governança corporativa implementada via AWS IAM Identity Center com privilégio mínimo para os 4 setores da empresa.
* **Obsessão por Performance:** Uso de banco de dados NoSQL (DynamoDB) de chave-valor para latências de um dígito de milissegundo.
