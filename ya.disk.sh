#!/bin/bash

echo "Устанавливаем davfs2"
sudo apt-get install davfs2 > /dev/null
echo "Разрешаем монтировать диск всем пользователям"
sudo dpkg-reconfigure davfs2
echo "Добавляем пользователя $USER в группу davfs2"
sudo usermod -aG davfs2 $USER
echo "Имя папки:"
read folder
echo "Создаем папку Яндекс.Диск ($HOME/$folder)"
mkdir -p "$HOME/$folder"
echo "Имя пользователя:"
read username
echo "Пароль:"
read -s password
echo "Выставляем права на $HOME/.davfs2/secrets"
sudo chmod 600 $HOME/.davfs2/secrets
if sudo grep -Fxq "$HOME/$folder $username $password" $HOME/.davfs2/secrets
then
	echo "Такая запись уже есть в $HOME/.davfs2/secrets"
else
	echo "Добавляем запись в $HOME/.davfs2/secrets"
	echo "$HOME/$folder $username $password" | sudo tee -a $HOME/.davfs2/secrets >> /dev/null
fi
if sudo grep -Fxq "https://webdav.yandex.ru:443 $HOME/$folder davfs noauto,user 0 0" /etc/fstab
then
	echo "Такая запись уже есть в /etc/fstab"
else
	echo "Добавляем запись в /etc/fstab"
	echo "https://webdav.yandex.ru:443 $HOME/$folder davfs noauto,user 0 0" | sudo tee -a /etc/fstab >> /dev/null
fi
echo "Теперь нужна перезагрузка"
echo "Монтировать Яндекс.Диск можно командой mount $HOME/$folder"
