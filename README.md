# 🚚 LogiTrack SaaS — Infraestrutura como Código & CI/CD Automatizado

A **LogiTrack** é uma startup de tecnologia logística B2B operando no modelo SaaS (Software as a Service). Este repositório contém o desenho, o provisionamento e a automação de toda a infraestrutura global da empresa na **AWS**, simulando um ambiente corporativo real, resiliente e enxuto.

O grande diferencial deste projeto é a **eliminação completa de configurações manuais**. Toda a infraestrutura é gerenciada de forma declarativa via **Terraform** e implantada automaticamente através de uma esteira de **CI/CD com GitHub Actions**.

---

## 🎯 O Cenário de Negócio

### 🔍 O que é?
A LogiTrack oferece uma API de altíssima velocidade para cálculo de frete, roteirização inteligente e previsão de entrega em tempo real para pequenas e médias plataformas de e-commerce.

### ⚠️ O Problema que Resolvemos
1. **Ineficiência no E-commerce:** Pequenos e-commerces não têm tecnologia para integrar de forma rápida com dezenas de transportadoras.
2. **Abandono de Carrinho:** A lentidão no cálculo do frete no checkout faz o cliente desistir. Nossa API Serverless responde em menos de 100ms.
3. **Falta de Previsibilidade:** Centralizamos o histórico de consultas para prever gargalos de entrega antes que eles aconteçam.

---

## 🧭 Diretrizes de Engenharia e Cultura (Foco 80/20)

Como uma startup enxuta limitada a **no máximo 4 funcionários por setor**, a engenharia da LogiTrack segue três princípios rígidos do *AWS Well-Architected Framework*:

*   **Infraestrutura como Código (IaC):** 100% dos recursos são declarados em arquivos `.tf` utilizando o **Terraform**. Mudanças no ambiente são auditáveis, replicáveis e versionadas.
*   **GitOps & CI/CD Contínuo:** Ninguém possui permissão para criar recursos manualmente no console de produção. O deploy é controlado pelo **GitHub Actions** através de automações que executam `terraform apply` de forma segura.
*   **Frugalidade Serverless (Custo Zero):** Arquitetura baseada em AWS Lambda, API Gateway e DynamoDB On-Demand. O custo operacional é estritamente baseado no uso (*Pay-as-you-go*), mantendo a infraestrutura no **AWS Free Tier (\$0.00 USD/mês)**.

---

## 🏢 Estrutura Organizacional Corporativa

A governança e o acesso à nuvem são divididos em 4 departamentos simulados (limite de 4 pessoas por setor) gerenciados via AWS IAM Identity Center (SSO):

*   **👥 Diretoria (C-Level):** Acesso de auditoria global (`ReadOnlyAccess`) para acompanhamento estratégico.
*   **👥 Desenvolvimento (Dev):** Permissão de escrita de código e leitura de logs. Bloqueados para deletar infraestrutura de produção.
*   **👥 Operações & Infra (DevOps):** Responsáveis pela manutenção dos módulos do Terraform e segredos das esteiras de automação.
*   **👥 Finanças & RH (Biz):** Acesso estrito e exclusivo ao *AWS Billing* e controle de alertas do AWS Budgets.

---

## 🌐 Arquitetura de Referência (AWS Serverless)

```text
[ E-commerce Cliente ] ──► [ Amazon API Gateway ] ──► [ AWS Lambda ] ──► [ Amazon DynamoDB ]
                                                          (Python)            (NoSQL)
```

---

## 🚀 Roadmap de Engenharia (Status do Projeto)

* [x] **Fase 1: Governança, Identidade e FinOps** ([Ver documentação](./fase-1-governanca/))
* [x] **Fase 2: Infraestrutura como Código (IaC) com Terraform** ([Ver código](./fase-2-iac-terraform/))
* [x] **Fase 3: Lógica de Negócios da API Serverless** ([Ver backend](./fase-3-api-serverless/))
* [x] **Fase 4: GitOps Pipeline com GitHub Actions (CI/CD Contínuo)** ([Ver esteira automatizada](./.github/workflows/))

---

## 🧪 Evidência de Funcionamento em Produção (Fase 4 GitOps)

Para validar o sucesso do deploy automatizado e comprovar a integração real entre o **Amazon API Gateway**, a função **AWS Lambda (Python)** e o **Amazon DynamoDB**, foi realizado um disparo de teste ponta a ponta via terminal utilizando o utilitário `curl`.

### 1. Chamada de Teste via Terminal (Request)
```bash
curl -X POST https://amazonaws.com \
     -H "Content-Type: application/json" \
     -d '{
       "client_id": "1002",
       "origin_zip": "01001-000",
       "destination_zip": "70002-000",
       "weight_kg": 2.5
     }'
```

### 2. Resposta de Alta Performance Recebida (Response)
```json
{
  "quote_id": "Q-C5A47250",
  "carrier": "LogiTrack Ninja",
  "delivery_days": 3,
  "shipping_cost": 16.25,
  "status": "Calculado e Armazenado"
}
```

> 💡 **Nota de Engenharia:** O status `"Calculado e Armazenado"` comprova que a regra de negócio em Python processou as variáveis numéricas com precisão decimal, gerou o ID único da cotação e realizou a persistência física do registro dentro da tabela NoSQL no DynamoDB com latência inferior a 100ms.

---
🔬 *Nota: Este projeto foi desenvolvido para fins educacionais de portfólio de engenharia, aplicando os padrões mais rígidos de automação e segurança exigidos pelo mercado de trabalho.*
