#!/bin/bash

# Dossiers et accès
DEST_USER="backupsite"
DEST_HOST="87.106.123.59"
BACKUP_DATE=$(date '+%Y-%m-%d')
DEST_PATH="/home/backupsite/backup/${BACKUP_DATE}"

# Date du jour (pour les logs)
DATE=$(date '+%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/backup_presta.log"

sshpass -p "$1" ssh -o StrictHostKeyChecking=no \
${DEST_USER}@${DEST_HOST} "mkdir -p ${DEST_PATH}"

# Exécution
echo "[$DATE] Début du transfert..."

sshpass -p "$1" ssh -o StrictHostKeyChecking=no \
${DEST_USER}@${DEST_HOST} \
"find /home/backupsite/backup -mindepth 1 -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;"

sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/themes" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/config" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/modules" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/img" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/upload" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/download" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/mails" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/html/perso/override" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/var/www/IA" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no "/var/www/html/perso/.htaccess" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1
sshpass -p "$1" scp -o StrictHostKeyChecking=no "/var/www/html/perso/robots.txt" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1

mysqldump -u maxence -p'Mj89si72jk*' SAEShop > /root/SAEShop_${BACKUP_DATE}.sql
sshpass -p "$1" scp -o StrictHostKeyChecking=no -r "/root/SAEShop_${BACKUP_DATE}.sql" ${DEST_USER}@${DEST_HOST}:${DEST_PATH} >> "$LOGFILE" 2>&1

rm -f /root/SAEShop_${BACKUP_DATE}.sql

if [ $? -eq 0 ]; then
  echo "[$DATE] Sauvegarde réussie"
else
  echo "[$DATE] Erreur lors du transfert"
fi