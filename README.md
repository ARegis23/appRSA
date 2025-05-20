# codandoemrsa

# esqueletoArquivos
lib/
│
├── main.dart                           # Setup inicial do app
|                           
├── core/
│   ├── routes.dart                     # Rotas de acesso
│   └── theme.dart                      # Temas claro e escuro
│
├── models/
│   └── user_model.dart                 # Modelo de dados do usuário
│
├── services/
│   ├── auth_service.dart               # Login/cadastro com Firebase
│   ├── key_generation_services.dart    # Funcoes para geracoes dos codigos RSA 'estilizado'
│   └── user_service.dart               # Gravação/consulta no Firestore
│
├── screens/
│   ├── about_screen.dart               # Interface sobre contato com desenvolvedores
│   ├── settings_screen.dart            # Interface para configuracoes do aplicativo
│   ├── login_screen.dart               # Interface para login ao aplicativo
│   ├── register_screen.dart            # Interface para cadastro de novo usuario
│   ├── forgot_password_screen.dart     # Interface para recuperacao de senha
│   ├── dashboard_screen.dart           # Interface para acesso as funcoes do sistema
│   ├── encrypt_screen.dart             # Interface para criptografar texto e gerar as chaves publicas e privadas
│   └── decrypt_screen.dart            # Interface para descriptografar texto
│
└── widgets/
    └── menu_card.dart                  # Modelo de configuracao dos dashboardcards


# documentacao
Codificação Personalizada
Objetivo
A Codificação Personalizada visa criar uma cifra única e dinâmica para cada usuário, combinando dados pessoais e informações temporais. Esse sistema oferece uma camada extra de segurança ao garantir que cada mensagem seja codificada de forma única, dependendo do usuário e do momento de uso.

Estrutura da Codificação
1. Alfabeto Base
O alfabeto base é a base para todas as mensagens codificadas e é composto por:

Letras maiúsculas: A–Z

Letras minúsculas: a–z

Números: 0–9

Caracteres especiais: !@#$%&*()-_+=<>?/[]{}|;:.,

Espaço em branco (código ASCII 32)

Exemplo do conjunto de caracteres (ASCII/UTF-8):

makefile
Copiar
Editar
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
Este conjunto contém 95 caracteres distintos, abrangendo os valores de 32 a 126 na tabela ASCII.

2. Personalização do Alfabeto (Alfabeto Pessoal)
A personalização do alfabeto cria um conjunto exclusivo de caracteres para cada usuário, embaralhando o alfabeto base com base em suas informações pessoais:

Obtenção de dados pessoais:

As três primeiras letras do nome do usuário.

As três primeiras letras do sobrenome do usuário.

A data de nascimento no formato MM/DD.

Processo:

As letras são convertidas para seus valores ASCII ou decimais.

A soma dos valores das letras é combinada com os valores de data de nascimento (MM/DD) e usada para criar offsets circulares para permutar o alfabeto base.

O resultado é um alfabeto embaralhado exclusivo para cada usuário.

3. Chave Temporal (Criptografia Dinâmica)
A chave temporal é gerada a partir do momento atual e é usada para garantir que cada mensagem codificada seja única, mesmo que os dados do usuário sejam os mesmos.

Cálculo da chave temporal:

A chave é formada pela combinação de dia (DD), hora (HH), minuto (MM) e segundo (SS).

Esse valor é convertido para inteiro ou vetor binário.

Aplicação da chave temporal:

A chave é utilizada para deslocar as posições dos caracteres da mensagem.

Também realiza-se um XOR com os valores binários dos caracteres para gerar a cifra.

Integração com RSA:

A chave temporal pode ser usada para gerar uma chave RSA, permitindo a criptografia da mensagem utilizando chave pública ou privada.

Resumo da Lógica
Etapa	O que faz	Objetivo
1. Alfabeto Base	Define todos os caracteres possíveis	Abrange qualquer tipo de mensagem
2. Personalização	Embaralha o alfabeto baseado em nome e aniversário	Gera um dicionário único por pessoa
3. Chave Temporal	Cria um fator de tempo para a cifra	Impede reutilização e permite múltiplas cifras por segundo

Características Principais
Pessoal: A cifra é única para cada usuário, com base em seus dados pessoais (nome, sobrenome, data de nascimento).

Temporal: A cifra é dinâmica e muda com o tempo, garantindo a segurança da comunicação.

Modular: A estrutura permite integração com outros sistemas de criptografia, como RSA ou AES.

Aplicações
Criptografia de mensagens pessoais: Mensagens codificadas de forma exclusiva, sem risco de reutilização.

Autenticação baseada em tempo: Impede o uso de mensagens antigas ou reutilizadas, aumentando a segurança.

Proteção de dados sensíveis: Utiliza chaves temporais e pessoais para proteger informações importantes.

Conclusão
Este sistema de Codificação Personalizada oferece uma solução segura e dinâmica para criptografar mensagens, garantindo que cada operação seja única, tanto para o usuário quanto para o momento de execução. A flexibilidade da solução permite a integração com outros sistemas de criptografia, tornando-a adequada para uma variedade de cenários de segurança.