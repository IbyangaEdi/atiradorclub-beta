#!/bin/bash
# Reempacota o protótipo como página autônoma e publica no GitHub Pages.
# O arquivo de origem é escrito para o wrapper do Artifact, sem <head> próprio.
set -euo pipefail

ORIGEM=/Users/edvalsantana/dev/marketplace-pce
DESTINO=/Users/edvalsantana/dev/atiradorclub-beta
cd "$DESTINO"

python3 - "$ORIGEM" <<'PY'
import pathlib, sys
origem = pathlib.Path(sys.argv[1])
novo = (origem / 'prototipo.html').read_text()

# tira o cabeçalho que só faz sentido dentro do Artifact
lixo = ['<title>Vitrine Atirador Club</title>\n',
        '<link rel="preconnect" href="https://fonts.googleapis.com">\n',
        '<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n']
fonte = ('<link rel="stylesheet" href="https://fonts.googleapis.com/css2?'
         'family=Barlow:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500'
         '&family=Saira:wght@500;600;700&display=swap">\n')
for l in lixo + [fonte]:
    assert novo.count(l) == 1, f'não encontrei: {l[:50]}'
    novo = novo.replace(l, '', 1)

# reaproveita o <head> já existente do site
atual = pathlib.Path('index.html').read_text()
marca = '</head>\n<body>\n'
head = atual[:atual.index(marca) + len(marca)]
saida = head + novo + '\n</body>\n</html>\n'

pathlib.Path('index.html').write_text(saida)
pathlib.Path('404.html').write_text(saida)
assert saida.count('<title>') == 1, 'title duplicado'
print(f'index.html reconstruído: {len(saida)} bytes')
PY

cp -f "$ORIGEM"/img/*.jpg img/

if git diff --quiet && git diff --cached --quiet; then
  echo "nada mudou"
  exit 0
fi

git add -A
git -c user.email=edval@berluc.com.br -c user.name="Edval Santana" \
    commit -qm "${1:-Atualiza o protótipo}"
git push -q origin main
echo "publicado — aguardando build do Pages"

# esperar só por status=built engana: ele ainda reporta o build anterior.
# o que vale é o build mais recente ser o do commit que acabou de subir.
SHA=$(git rev-parse HEAD)
API=repos/IbyangaEdi/atiradorclub-beta/pages/builds/latest
until [ "$(gh api $API --jq .commit 2>/dev/null)" = "$SHA" ] \
   && [ "$(gh api $API --jq .status 2>/dev/null)" = "built" ]; do
  sleep 8
done
echo "no ar: https://atiradorclub.berluc.com.br (commit ${SHA:0:7})"
