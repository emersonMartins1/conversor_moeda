# conversor_moeda

Este projeto foi construído seguindo as orientações do livro Iniciando com Flutter Framework, do autor Leonardo H Marinho.

O projeto é um aplicativo convesor de moedas que consume uma API da HG Brasil para carregar as cotações da atuais do dólar e do euro em reais por meio do protocolo HTTP get. Os dados referentes as cotações em dólar e real são recebidos no formato JSON e tratados pelo aplicativo.

Ao receber uma entrada do usuário em uma das três moedas disponíveis para conversão (real, dólar ou euro) o aplicativo utiliza as cotações consumidas anteriormente para calcular e exibir o valor convertido nas outras duas moedas.