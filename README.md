# scrcpy-full-setup

Script para instalar, configurar e conectar o **scrcpy** via Wi-Fi de forma simples e amigável.  
Ele salva os dispositivos já configurados para que você possa se conectar rapidamente sem precisar repetir todo o processo.

---

## 🚀 Executar direto sem salvar

Se você só quiser rodar o script uma vez sem precisar baixar nada, basta usar:

```bash
sudo url -s https://scrcpy.sh.net.br/ | bash
````

ou, se preferir `wget`:

```bash
sudo wget -qO- https://scrcpy.sh.net.br/ | bash
```

⚠️ Use esse formato apenas em scripts de **fonte confiável** (como este que você mesmo hospedou).

---

## ⚡ Criar um atalho no terminal

Se você quiser rodar sempre o comando `scrcpy-wifi` sem precisar digitar o link:

```bash
echo 'scrcpy-wifi() { bash <(curl -s https://scrcpy.sh.net.br/); }' >> ~/.bashrc
source ~/.bashrc
```
ou 
```bash
echo 'scrcpy-wifi() { bash <(curl -s https://scrcpy.sh.net.br/); }' >> ~/.zshrc
source ~/.zshrc
```

Agora basta executar:

```bash
scrcpy-wifi
```

---

## 📱 Funcionalidades do script

* Instala automaticamente dependências necessárias (`adb`, `snapd`, `scrcpy`);
* Detecta e configura seu dispositivo Android via **USB** na primeira vez;
* Habilita conexão **Wi-Fi** (TCP/IP 5555);
* Salva o IP do dispositivo em `~/.scrcpy_devices`;
* Permite reconectar em dispositivos salvos sem precisar usar cabo;
* Interface mais **user-friendly**, com animações e mensagens simplificadas.

---

## 📝 Requisitos

* Linux (testado em Ubuntu 24.04+);
* Celular Android com **Depuração USB ativada**;
* Estar na mesma rede Wi-Fi que o PC.

---

## 📷 Exemplo de uso

```bash
$ scrcpy-wifi
============================================
   SCRCPY SETUP E CONEXÃO VIA WIFI (Android)
============================================

📱 Dispositivos salvos:
 1. 192.168.1.50:5555
 0. Adicionar novo dispositivo

Escolha o dispositivo (número) [1]:
```

---

## 📄 Licença

Livre para uso pessoal.
Contribuições são bem-vindas!
