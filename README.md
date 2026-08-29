# 🚚 LogiTrack SaaS — Infraestrutura Cloud Serverless

A **LogiTrack** é uma startup de tecnologia logística B2B operando no modelo SaaS (Software as a Service). Este repositório contém o desenho, o provisionamento e a automação de toda a infraestrutura global da empresa na **AWS**, simulando um ambiente corporativo real e enxuto. 

O objetivo deste projeto é aplicar os conceitos das certificações AWS na resolução de problemas reais de negócio, utilizando práticas de **Segurança (Zero Trust)**, **Governança** e **Arquitetura Serverless (Custo Zero)**.

---

## 🎯 O Cenário de Negócio

### O que é?
A LogiTrack oferece uma API de altíssima velocidade para cálculo de frete, roteirização inteligente e previsão de entrega em tempo real para pequenas e médias plataformas de e-commerce.

### O Problema que Resolvemos
1. **Ineficiência no E-commerce:** Pequenos e-commerces não têm tecnologia para integrar de forma rápida com dezenas de transportadoras.
2. **Abandono de Carrinho:** A lentidão no cálculo do frete durante o checkout faz o cliente desistir. Nossa API responde em menos de 100ms.
3. **Falta de Previsibilidade:** Centralizamos o histórico de consultas para prever gargalos de entrega antes que eles aconteçam.

---

## 🧭 Diretrizes de Engenharia e Cultura

Como uma startup enxuta limitada a **no máximo 4 funcionários por setor**, a engenharia da LogiTrack segue três princípios rígidos do *AWS Well-Architected Framework*:

*   **Frugalidade (Eficiência de Custo):** Arquitetura 100% Serverless. O custo operacional é estritamente baseado no uso (*Pay-as-you-go*), mantendo a infraestrutura elegível ao **AWS Free Tier (\$0.00 USD/mês)** para validação.
*   **Segurança Baseada em Identidade (Zero Trust):** Isolamento absoluto de acessos corporativos implementado via AWS IAM Identity Center (SSO) com base no princípio do privilégio mínimo.
*   **Obsessão por Performance:** Uso de processamento assíncrono e banco de dados NoSQL de chave-valor para garantir latências de um dígito de milissegundo.
  ### 🛡️ Política Rígida de MFA (Multi-Factor Authentication)
Para mitigar riscos de roubo de credenciais, foi configurada uma política global de **MFA Obrigatório** no IAM Identity Center. Todos os colaboradores (inclusive os perfis simulados) são forçados a registrar um aplicativo de autenticação (TOTP) já no primeiro acesso ao portal SSO, bloqueando logins que utilizem apenas usuário e senha.


---

## 🏢 Estrutura Organizacional Corporativa

A governança e o acesso à nuvem são divididos em 4 departamentos simulados (limite de 4 pessoas por setor):

*   **👥 Diretoria (C-Level):** Acesso de auditoria global (`ReadOnlyAccess`) para acompanhamento de métricas e custos.
*   **👥 Desenvolvimento (Dev):** Permissões para gerenciar códigos, funções Lambda e visualizar logs de depuração. Sem acesso de exclusão em produção.
*   **👥 Operações & Infra (DevOps):** Acesso administrativo (`PowerUserAccess`) para provisionar redes, gerenciar tabelas e automações.
*   **👥 Finanças & RH (Biz):** Acesso restrito e exclusivo ao *AWS Billing and Cost Management* para controle de orçamentos (*FinOps*).

---

## 🌐 Arquitetura de Referência (AWS Serverless)

Abaixo está o fluxo de dados desenhado para suportar as requisições da nossa API logística:

```text
[ Plataforma de E-commerce ] 
             │
             ▼
      [ Amazon Route 53 ] (DNS Global)
             │
             ▼
     [ Amazon CloudFront ] (Distribuição Edge / SSL)
             │
             ▼
    [ Amazon API Gateway ] (Roteamento e Autenticação HTTPS)
             │
             ▼
       [ AWS Lambda ] (Lógica de Cálculo de Roteirização)
             │
             ▼
     [ Amazon DynamoDB ] (Banco NoSQL - Armazenamento de Histórico)
```

---

## 🚀 Roadmap de Implementação

O projeto está dividido em fases incrementais de engenharia:

*   [ ] **Fase 1:** Governança e Identidade corporativa com AWS IAM Identity Center e AWS Budgets.
*   [ ] **Fase 2:** Infraestrutura como Código (IaC) com AWS SAM/Terraform e isolamento de rede corporativa.
*   [ ] **Fase 3:** Implantação do Backend da API Serverless (API Gateway + Lambda + DynamoDB).
*   [ ] **Fase 4:** Automação e Esteira de CI/CD integrada ao GitHub Actions.

---
🔬 *Nota: Este projeto foi desenvolvido para fins educacionais de portfólio, aplicando conceitos avançados de Cloud Architecture.*
