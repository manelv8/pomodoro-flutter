# Pomodoro Flutter

Aplicativo Pomodoro em Flutter com deploy manual para GitHub Pages na branch `gh-pages`.

## Deploy manual

Este repositório está configurado para publicar o build web em:

`https://pomodoro.estribado.com.br/`

O script de deploy está em [scripts/deploy-gh-pages.ps1](/C:/Users/davie/Documents/projects/pomodoro_flutter/scripts/deploy-gh-pages.ps1) e executa este fluxo:

- roda `fvm flutter test`
- roda `fvm flutter build web --release --base-href /`
- copia `web/CNAME` para o build
- publica o conteúdo de `build/web` na branch `gh-pages`

### Comando único

No PowerShell, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\deploy-gh-pages.ps1
```

Se o seu ambiente já permitir execução de scripts, também pode rodar:

```powershell
.\scripts\deploy-gh-pages.ps1
```

## Pré-requisitos

- `git`
- `fvm`
- acesso de push ao remoto `origin`

O script usa a URL configurada em `git remote get-url origin`. Hoje o remoto esperado é o repositório `manelv8/pomodoro-flutter`.

## Configuração do GitHub Pages

No repositório `manelv8/pomodoro-flutter`:

1. Abra `Settings > Pages`.
2. Em `Source`, selecione `Deploy from a branch`.
3. Em `Branch`, selecione `gh-pages`.
4. Em pasta, selecione `/ (root)`.
5. Em `Custom domain`, use `pomodoro.estribado.com.br`.

Depois do primeiro deploy manual, o GitHub Pages publicará o conteúdo da branch `gh-pages`.

## Configuração do domínio

O arquivo [web/CNAME](/C:/Users/davie/Documents/projects/pomodoro_flutter/web/CNAME) já está versionado com:

```txt
pomodoro.estribado.com.br
```

No Cloudflare, configure:

- tipo: `CNAME`
- nome: `pomodoro`
- destino: `manelv8.github.io`

Se houver problema inicial de certificado ou validação do GitHub Pages, teste primeiro com `DNS only` no Cloudflare antes de reativar o proxy.

## O que o script faz

1. Valida os testes com `fvm flutter test`.
2. Gera o build web com base `/`.
3. Garante `CNAME` e `.nojekyll` dentro de `build/web`.
4. Cria um repositório temporário com o conteúdo compilado.
5. Faz `push --force` para a branch `gh-pages`.

Esse `push --force` é intencional: a branch `gh-pages` deve conter apenas os arquivos gerados do site.
