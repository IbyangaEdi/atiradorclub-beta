# Atirador Club — beta

Protótipo navegável do marketplace de produtos controlados pelo Exército.
Publicado em **https://atiradorclub.berluc.com.br**

> **Versão de testes.** Não há backend, autenticação real nem banco de dados.
> Todos os anunciantes, anúncios, preços e conversas são fictícios.
> As fotos de produto são material de referência de terceiros, usado apenas
> para validação visual — na plataforma, quem envia a foto é o vendedor.

## O que dá para testar

| Tela | O que ver |
|---|---|
| **Login** | Qualquer e-mail e senha entram. Há também um atalho "entrar sem cadastro". |
| **Criar conta** | Dois tipos de conta (CAC PF e Loja PJ), anexo obrigatório de CR e CPF, validade do CR com recusa de documento vencido. |
| **Home** | Busca com dicionário de sinônimos (`9mm`, `red dot`, `pólvora`) e trilhas por categoria, proximidade e reputação. |
| **Busca** | Filtros por categoria, preço, calibre, marca, condição, UF e verificação; grade de 3 colunas. |
| **Paióis** | Barra com as 27 UFs. Sem estado selecionado, a ordem é a distância real até a região escolhida. |
| **Negociações** | Conversas com a máquina de estados do pedido. A conversa com André M. demonstra o bloqueio antidesintermediação. |

## Estrutura

```
index.html   página única, sem dependências externas além do Google Fonts
img/         36 fotos de produto (640x480, JPEG)
CNAME        domínio customizado do GitHub Pages
robots.txt   bloqueia indexação enquanto for beta
```

## Decisões de produto embutidas na interface

- Vendedor pessoa física aparece com **nome abreviado e cidade**, nunca nome completo.
- O card informa **"série verificada"**, nunca o número de série.
- Estado nunca é comunicado só por cor: todo selo leva ícone e palavra.
- Negociação fora da plataforma é mascarada na própria bolha e congela a conversa.
