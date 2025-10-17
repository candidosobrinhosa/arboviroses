#!/usr/bin/env bash

# -------------------------------------------------------------------------
# Baixar arquivos CSV do SINAN/Zika (2016–2025)
# -------------------------------------------------------------------------

OUTDIR="./dados_zika"
CSVDIR="${OUTDIR}/csv"
LOGFILE="${OUTDIR}/log_zika.txt"

mkdir -p "$OUTDIR" "$CSVDIR"

BASE_URL="https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SINAN/Zikavirus/csv"
ANO_INICIAL=2016
ANO_FINAL=2025

# Cabeçalho do log se ainda não existir
if [[ ! -f "$LOGFILE" ]]; then
    echo -e "DataHora\tArquivo\tMD5\tStatus" > "$LOGFILE"
fi

for ((ano=$ANO_INICIAL; ano<=$ANO_FINAL; ano++)); do
    SUFIXO=$(printf "%02d" $((ano - 2000)))
    ARQ="ZIKABR${SUFIXO}.csv.zip"
    URL="${BASE_URL}/${ARQ}"
    DEST="${OUTDIR}/${ARQ}"
    MD5_FILE="${DEST}.md5"
    TEMP_DL="${DEST}.tmp"

    echo "🔹 Verificando: $ARQ"

    # Verifica a data de modificação remota
    REMOTE_DATE=$(curl -sI "$URL" | grep -i '^Last-Modified:' | cut -d' ' -f2-)
    REMOTE_UNIX=$(date -d "$REMOTE_DATE" +%s 2>/dev/null || echo 0)
    LOCAL_UNIX=$(stat -c %Y "$DEST" 2>/dev/null || echo 0)

    # Caso o arquivo local já exista e seja mais novo ou igual, pula
    if (( REMOTE_UNIX <= LOCAL_UNIX )) && [[ -f "$DEST" ]]; then
        STATUS="SEM_MODIFICACAO"
        MD5SUM=$(cut -d' ' -f1 "$MD5_FILE" 2>/dev/null || echo "-")
        echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$ARQ\t$MD5SUM\t$STATUS" >> "$LOGFILE"
        echo "⚪ $ARQ já está atualizado."
        continue
    fi

    # Baixar apenas se houver versão nova
    if curl -s -L -R -z "$DEST" -o "$TEMP_DL" "$URL"; then
        if [[ -s "$TEMP_DL" ]]; then
            mv "$TEMP_DL" "$DEST"
            MD5SUM=$(md5sum "$DEST" | awk '{print $1}')
            echo "$MD5SUM  $ARQ" > "$MD5_FILE"

            # Novo ou atualizado?
            if [[ $LOCAL_UNIX -eq 0 ]]; then
                STATUS="NOVO"
            else
                STATUS="ATUALIZADO"
            fi

            echo "✅ $ARQ -> $STATUS"

            # Só extrai se for NOVO ou ATUALIZADO
            if [[ "$STATUS" == "NOVO" || "$STATUS" == "ATUALIZADO" ]]; then
                unzip -qo "$DEST" -d "$CSVDIR"
                echo "📂 Extraído para $CSVDIR"
            fi

            echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$ARQ\t$MD5SUM\t$STATUS" >> "$LOGFILE"
        else
            echo "⚠️  Arquivo não encontrado no servidor: $URL"
            echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$ARQ\t-\tNAO_ENCONTRADO" >> "$LOGFILE"
        fi
    else
        echo "❌ Erro ao baixar $ARQ"
        echo -e "$(date '+%Y-%m-%d %H:%M:%S')\t$ARQ\t-\tERRO" >> "$LOGFILE"
        [[ -f "$TEMP_DL" ]] && rm -f "$TEMP_DL"
    fi
done
