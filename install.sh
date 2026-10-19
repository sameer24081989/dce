#!/usr/bin/env bash
set -euo pipefail
# Unprivileged installer. Does not change system services, DNS, TLS or production data.
if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo 'Usage: bash sdc/install.sh ABSOLUTE_NEW_DIRECTORY ADMINISTRATOR_EMAIL REASON [OBJECT_EXPORT_JSON]' >&2
  exit 2
fi
install_root=$1
admin_email=$2
install_reason=$3
backup_path=${4:-}
[[ "$install_root" = /* && ! -e "$install_root" ]] || { echo 'Destination must be a new absolute directory; refusing overwrite' >&2; exit 1; }
node --input-type=module -e "import{DatabaseSync}from'node:sqlite';if(+process.versions.node.split('.')[0]<24)process.exit(1);new DatabaseSync(':memory:').close();"
source_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
[[ "$install_root" != "$source_root" && "$install_root" != "$source_root/"* ]] || { echo "Destination must be outside the source tree" >&2; exit 1; }
umask 077
mkdir -p "$install_root/app" "$install_root/data" "$install_root/config"
for entry in worker sdc tools tests templates scripts reports package.json .dockerignore; do
  [[ ! -e "$source_root/$entry" ]] || cp -R "$source_root/$entry" "$install_root/app/"
done
cp "$source_root/sdc/deploy/dce.env.example" "$install_root/config/dce.env"
if [[ -n "$backup_path" ]]; then
  node "$install_root/app/sdc/initialize.mjs" --database "$install_root/data/register.sqlite" --backup "$backup_path" --administrator "$admin_email" --reason "$install_reason" --confirm-empty-target
else
  node "$install_root/app/sdc/initialize.mjs" --database "$install_root/data/register.sqlite" --administrator "$admin_email" --reason "$install_reason" --confirm-empty-target
fi
node --input-type=module -e 'import{readFileSync,writeFileSync}from"node:fs";const[p,db,email]=process.argv.slice(1);let s=readFileSync(p,"utf8");s=s.replace(/^SDC_DATABASE=.*$/m,"SDC_DATABASE="+JSON.stringify(db)).replace(/^SDC_REGISTER_OWNER_EMAIL=.*$/m,"SDC_REGISTER_OWNER_EMAIL="+JSON.stringify(email.trim().toLowerCase()));writeFileSync(p,s,{mode:0o600});' "$install_root/config/dce.env" "$install_root/data/register.sqlite" "$admin_email"
printf '%s\n' 'Application and empty-target database installed. Fill config/dce.env with approved origin/OIDC values and the installed database path before starting. No service, network deployment or scheduler was enabled.'
