#!/bin/bash

[ "$EUID" -eq 0 ] && echo "É necessário rodar o script como usuário normal, não como root." && exit 1

app_ok=1

apps=("i3-gaps" "i3blocks" "dunst" "xdotool" "cantarell-fonts" "ttf-hack")

for app in ${apps[@]}; do
	pacman -Q $app 1> /dev/null 2> /dev/null
	if [ $? = 1 ]; then
		echo "$app não instalado. Instale primeiro."
		app_ok=0
	fi
done

[ "$app_ok" -eq 0 ] && echo "Existem dependências, programa abortado." && exit 1

backup_date=$(date +'%s')

# i3
if [ -d ${HOME}/.config/i3 ]; then
	if [ -f ${HOME}/.config/i3/config ]; then
		mv ${HOME}/.config/i3/config ${HOME}/.config/i3/config-${backup_date}.bkp
	fi
else
	mkdir -p ${HOME}/.config/i3
fi

echo "Instalando as configs do i3..."
curl -s -o ${HOME}/.config/i3/config 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/i3/config'

# i3blocks
if [ -d ${HOME}/.config/i3blocks ]; then
	if [ -f ${HOME}/.config/i3blocks/config ]; then
		mv ${HOME}/.config/i3blocks/config ${HOME}/.config/i3blocks/config-${backup_date}.bkp
	fi
else
	mkdir -p ${HOME}/.config/i3blocks
fi

echo "Instalando as configs do i3blocks..."
curl -s -o ${HOME}/.config/i3blocks/config 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/i3blocks/config.airblader'
curl -s -o ${HOME}/.config/i3blocks/cores.conf 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/i3blocks/cores.conf'

# i3blocks scripts
if [ -d ${HOME}/.config/i3blocks/scripts ]; then
	mv ${HOME}/.config/i3blocks/scripts ${HOME}/.config/i3blocks/scripts-${backup_date}
else
	mkdir -p ${HOME}/.config/i3blocks/scripts
fi

scripts=("blank"
		"cpu"
		"disk"
		"firewall"
		"focus"
		"hora"
		"mem"
		"mpd"
		"packages"
		"temperature"
		"trash"
		"uptime"
		"volume"
		"wallpaper"
		"weather"
		"wifi")

for script in ${scripts[@]}; do
	curl -s -o ${HOME}/.config/i3blocks/scripts/${script} "https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/i3blocks/${script}"
done

# dunst
if [ -d ${HOME}/.config/dunst ]; then
	if [ -f ${HOME}/.config/dunst/dunstrc ]; then
		mv ${HOME}/.config/dunst/dunstrc ${HOME}/.config/dunst/dunstrc-${backup_date}.bkp
	fi
else
	mkdir -p ${HOME}/.config/i3blocks/scripts
fi

curl -s -o ${HOME}/.config/dunst/dunstrc 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/dunst/dunstrc'

# rofi
if [ -d ${HOME}/.config/rofi ]; then
	if [ -d ${HOME}/.config/rofi/scripts ]; then
		mv ${HOME}/.config/rofi/scripts ${HOME}/.config/rofi/scripts-${backup_date}
	else
		mkdir -p ${HOME}/.config/rofi/scripts
	fi

	if [ -f ${HOME}/.config/rofi/config.rasi ]; then
		mv ${HOME}/.config/rofi/config.rasi ${HOME}/.config/rofi/config-${backup_date}.rasi.bkp
	fi
else
	mkdir -p ${HOME}/.config/rofi/scripts
fi

curl -s -o ${HOME}/.config/rofi/config.rasi 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/rofi/config.rasi'
curl -s -o ${HOME}/.config/rofi/scripts/apps 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/rofi/scripts/apps'
curl -s -o ${HOME}/.config/rofi/scripts/configs 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/rofi/scripts/configs'
curl -s -o ${HOME}/.config/rofi/scripts/power 'https://raw.githubusercontent.com/sistematico/majestic/master/home/lucas/.config/rofi/scripts/power'

# fontawesome
fc-list | grep -i FontAwesome 1> /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
	echo "FontAwesome não encontrado, instalando..."
	curl -s http://fontawesome.io/assets/font-awesome-4.7.0.zip > /tmp/font-awesome-4.7.0.zip
	unzip /tmp/font-awesome-4.7.0.zip -d /tmp/
	if [ ! -d ${HOME}/.fonts ]; then
		mkdir ${HOME}/.fonts
	fi
	cp /tmp/font-awesome-4.7.0/fonts/fontawesome-webfont.ttf ${HOME}/.fonts/fontawesome.ttf
	fc-cache -v -f
fi

echo "Tudo pronto!"

#i3-msg reload
#i3-msg restart

