import math
import random

# Constante: alfabeto original
ALFABETO_BASE = (
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÉÍÓÚÂÊÔÃÕÀÈÌÙÇáéíóúâêôãõàèìùç0123456789 !@#$%&*()-_=+[]{};:,.<>?/|\\\"'"
)

# Variáveis globais
ALFABETO = "" 
BLOCO_TAMANHO_GLOBAL = None

# Funções auxiliares matemáticas
def mdc(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def modinv(a, m):
    m0, x0, x1 = m, 0, 1
    while a > 1:
        q = a // m
        a, m = m, a % m
        x0, x1 = x1 - q * x0, x0
    return x1 % m0

def is_prime(n):
    if n < 2:
        return False
    if n % 2 == 0 and n != 2:
        return False
    for i in range(3, int(math.isqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True

# Embaralhar alfabeto com chave
def embaralhar_alfabeto(chave_personalizada):
    if len(chave_personalizada) != 7 or not chave_personalizada[:3].isalpha() or not chave_personalizada[3:].isdigit():
        raise ValueError("A chave deve conter 3 letras seguidas por 4 números, como 'abc1234'.")

    random.seed(chave_personalizada)
    alfabeto_lista = list(ALFABETO_BASE)
    random.shuffle(alfabeto_lista)
    return ''.join(alfabeto_lista)

# Conversão entre caracteres e índices
def char_to_index(c, alfabeto):
    return alfabeto.index(c)

def index_to_char(i, alfabeto):
    return alfabeto[i]

# Função principal
def menu_rsa_personalizado():
    global ALFABETO
    global BLOCO_TAMANHO_GLOBAL


    # Menu principal
    while True:
        print("\n--- RSA com Alfabeto Personalizado ---")
        print("1. Gerar chaves")
        print("2. Criptografar")
        print("3. Descriptografar")
        print("4. Sair")

        opcao = input("Escolha uma opção: ")

        if opcao == "1":
    # Solicita chave personalizada
            while True:
                chave_personalizada = input("Por favor, digite sua chave personalizada (ex: abc1234): ")
                try:
                    ALFABETO = embaralhar_alfabeto(chave_personalizada)
                    print(f"Alfabeto personalizado gerado:...")
                    break
                except ValueError as e:
                    print(f"Erro: {e} Tente novamente.")

            try:
                p = int(input("Digite um número primo P: "))
                q = int(input("Digite um número primo Q: "))

                if not is_prime(p) or not is_prime(q):
                    print("Erro: P e Q devem ser primos.")
                    continue

                n = p * q
                phi = (p - 1) * (q - 1)
                e = 3
                while e < phi:
                    if mdc(e, phi) == 1:
                        break
                    e += 2

                d = modinv(e, phi)
                BLOCO_TAMANHO_GLOBAL = len(str(pow(len(ALFABETO) - 1, e, n)))

                print("\n--- Chaves Geradas ---")
                print("Chave pública (n, e):", n, e)
                print("Chave privada (n, d):", n, d)
            except Exception as erro:
                print("Erro ao gerar as chaves:", erro)

        elif opcao == "2":
            try:
                # Solicita a chave personalizada para gerar o alfabeto correto
                while True:
                    chave_personalizada = input("Digite a chave personalizada usada na criptografia (ex: abc1234): ")
                    try:
                        ALFABETO = embaralhar_alfabeto(chave_personalizada)
                        break
                    except ValueError as e:
                        print(f"Erro: {e} Tente novamente.")

                assert ALFABETO, "Alfabeto não definido. Gere uma chave personalizada válida."

                n = int(input("Digite o valor de n (público): "))
                e = int(input("Digite o valor de e (público): "))

                BLOCO_TAMANHO_GLOBAL = len(str(pow(len(ALFABETO) - 1, e, n)))

                mensagem = input("Digite a mensagem: ")

                criptografada = ''.join(
                    str(pow(char_to_index(c,ALFABETO), e, n)).zfill(BLOCO_TAMANHO_GLOBAL)
                    for c in mensagem
                )

                print("\nMensagem criptografada:")
                print(criptografada)
            except Exception as erro:
                print("Erro na criptografia:", erro)

        elif opcao == "3":
            try:
                # Solicita novamente a chave personalizada usada na criptografia
                while True:
                    chave_personalizada = input("Digite a chave personalizada usada na criptografia (ex: abc1234): ")
                    try:
                        ALFABETO = embaralhar_alfabeto(chave_personalizada)
                        break
                    except ValueError as e:
                        print(f"Erro: {e} Tente novamente.")

                assert ALFABETO, "Alfabeto não definido. Gere uma chave personalizada válida."
                
                n = int(input("Digite o valor de n (privado): "))
                d = int(input("Digite o valor de d (privado): "))
                criptografada = input("Digite a mensagem criptografada: ").strip()

                if BLOCO_TAMANHO_GLOBAL is None:
                    for tam_candidato in range(1, 100):
                        if len(criptografada) % tam_candidato == 0:
                            try:
                                bloco_teste = criptografada[:tam_candidato]
                                dec_teste = pow(int(bloco_teste), d, n)
                                if 0 <= dec_teste < len(ALFABETO):
                                    BLOCO_TAMANHO_GLOBAL = tam_candidato
                                    print(f"Tamanho de bloco detectado: {BLOCO_TAMANHO_GLOBAL}")
                                    break
                            except:
                                continue
                    if BLOCO_TAMANHO_GLOBAL is None:
                        print("Não foi possível determinar o tamanho do bloco para descriptografia.")
                        continue

                mensagem = ""
                for i in range(0, len(criptografada), BLOCO_TAMANHO_GLOBAL):
                    bloco = criptografada[i:i + BLOCO_TAMANHO_GLOBAL]
                    try:
                        dec = pow(int(bloco), d, n)
                        if not (0 <= dec < len(ALFABETO)):
                            print(f"[!] Bloco inválido: {bloco} → {dec}")
                            mensagem += "?"
                            continue
                        mensagem += index_to_char(dec, ALFABETO)
                    except Exception as erro:
                        print(f"[!] Erro no bloco {bloco}: {erro}")
                        mensagem += "?"

                print("Mensagem descriptografada:")
                print(mensagem)

            except Exception as erro:
                print("Erro durante a descriptografia:", erro)

        elif opcao == "4":
            print("Encerrando o programa.")
            break
            
        else:
            print("Opção inválida. Tente novamente.")


# Executar
menu_rsa_personalizado()
