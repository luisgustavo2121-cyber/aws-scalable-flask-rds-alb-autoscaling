# 🚀 Aplicação Flask Escalável na AWS com RDS, ALB e Auto Scaling

## 📌 Visão Geral

Este projeto demonstra a implementação de uma aplicação web escalável e resiliente utilizando Python (Flask) e serviços da AWS.

A solução foi construída com foco em arquitetura de produção, utilizando balanceamento de carga, escalabilidade automática e banco de dados gerenciado.

---

## 🧠 Arquitetura

```
Internet
   ↓
Application Load Balancer (ALB)
   ↓
Auto Scaling Group (EC2)
   ↓
Aplicação Flask (Python)
   ↓
Amazon RDS (PostgreSQL)
```

---

## 🧱 Tecnologias Utilizadas

* AWS EC2
* AWS RDS (PostgreSQL)
* AWS Application Load Balancer (ALB)
* AWS Auto Scaling Group (ASG)
* Python (Flask)
* Amazon Linux
* systemd (gerenciamento de serviço)

---

## ⚙️ Funcionalidades

* ✔ Escalabilidade automática com Auto Scaling
* ✔ Balanceamento de carga com ALB
* ✔ Persistência de dados com RDS
* ✔ Provisionamento automático via User Data
* ✔ Aplicação gerenciada como serviço (systemd)
* ✔ Alta disponibilidade e tolerância a falhas

---

## 🔐 Segurança

* Banco de dados RDS sem acesso público
* Acesso ao banco restrito ao Security Group das instâncias EC2
* Porta 22 (SSH) limitada ao IP autorizado
* Tráfego HTTP controlado via Load Balancer

---

## 🚀 Estratégia de Deploy

Cada instância EC2 é configurada automaticamente ao iniciar, utilizando **User Data**, que realiza:

* Instalação do Python e dependências
* Deploy da aplicação Flask
* Configuração de variáveis de ambiente
* Criação de serviço systemd
* Inicialização automática da aplicação

---

## 🔗 Endpoints

* `/` → Verificação de funcionamento da aplicação
* `/add` → Inserção de dados no banco
* `/list` → Consulta de dados armazenados

---

## 🧪 Testes Realizados

* ✔ Acesso à aplicação via DNS do ALB
* ✔ Distribuição de carga entre múltiplas instâncias
* ✔ Instâncias marcadas como **healthy** no Target Group
* ✔ Criação automática de instâncias pelo Auto Scaling
* ✔ Aplicação continua disponível mesmo com falha de instância

---

## ⚠️ Problemas Enfrentados e Soluções

### 🔴 Falha na execução do User Data

* Causa: problemas de formatação e contexto de execução
* Solução: simplificação do script e melhoria nos logs

---

### 🔴 Erro de ambiente Python (Flask não encontrado)

* Causa: conflito entre `pip` e `python`
* Solução: uso de `python3 -m pip`

---

### 🔴 Aplicação não persistente

* Causa: uso de `nohup` sem controle adequado
* Solução: implementação de serviço com **systemd**

---

### 🔴 Erro 502 no Load Balancer

* Causa: aplicação não estava rodando corretamente
* Solução: garantir inicialização confiável via systemd

---

## 📚 Aprendizados

* Diferença entre erros de infraestrutura e aplicação
* Debug de scripts de inicialização (cloud-init / user-data)
* Importância do ambiente de execução em aplicações Python
* Funcionamento do ALB e health checks
* Construção de sistemas resilientes em cloud

---

## 🚀 Melhorias Futuras

* Implementação de HTTPS com AWS ACM
* Uso de Nginx como reverse proxy
* Pipeline CI/CD (GitHub Actions)
* Monitoramento com CloudWatch
* Containerização com Docker

---

## 👨‍💻 Luis Gustavo

Projeto desenvolvido como prática avançada em Cloud Computing e desenvolvimento backend, com foco em arquitetura escalável na AWS.
